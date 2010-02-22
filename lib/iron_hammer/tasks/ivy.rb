require 'iron_hammer'
require 'iron_hammer/utils/topological_sort'

CLEAN.include('Libraries/*')

namespace :iron do
  namespace :ivy do
    def all_dependencies
      unless @all_dependencies
        @all_dependencies = []
        @anvil.projects.each do |project|
          project.dependencies.each do |dependency|
            @all_dependencies << dependency unless @all_dependencies.include? dependency
          end
        end
      end
      @all_dependencies
    end

    desc 'Publishes project dependencies into ivy repository'
    task :setup, [:binaries_path] do |t, args|

      files = Dir.new(args.binaries_path).entries
      candidates = all_dependencies.select {|x| files.include? "#{x.name}.#{x.extension}"}

      candidates.each do |dependency|
        sh "java -jar #{IVY_JAR} -settings #{IVY_SETTINGS} -dependency #{ORGANISATION} #{dependency.name} #{dependency.version}" do |ok, res|
          unless res.exitstatus == 0
            dependency_project = DependencyProject.new(
            :name => dependency.name,
            :binaries_path => args.binaries_path,
            :version => dependency.version,
            :extension => dependency.extension)

            puts "Dependency #{dependency.name}"

            builder = IvyConfiguration.builder_for dependency_project

            builder.write_to "ivy-#{dependency.name}.xml"

            sh builder.publish "ivy-#{dependency.name}.xml"
          end
        end
      end
    end

    desc 'Generates ivy-<project_name>.xml for all projects of the solution'
    task :generate do
      puts "Generating ivy files for projects"
      @anvil.projects.each do |project|
        builder = IvyConfiguration.builder_for project
        builder.write_to "ivy-#{project.name}.xml"
      end
    end

    desc 'Retrieves all project dependencies from ivy repository and modify project csproj to reference them'
    task :retrieve do
      builder = IvyConfiguration.builder_for(SolutionProject.new(@anvil.solution.name, all_dependencies))
      xml = "ivy-#{@anvil.solution.name}.xml"
      builder.write_to xml

      sh builder.retrieve xml

      @anvil.projects.each do |project|
        builder = IvyConfiguration.builder_for project

        builder.modify_csproj
      end
      IvyBuilder.rename_artifacts
    end

    desc 'Publishes project assemblies to ivy repository (only dll projects)'
    task :publish => [:generate] do
      @anvil.dll_projects.topological_sort.each do |project|
        xml = "ivy-#{project.name}.xml"
        builder = IvyConfiguration.builder_for project

        FileSystem.write! :name => xml, :path => '.',
          :content => builder.generate_xml(project.dependencies_with_projects @anvil.projects)

        sh builder.publish xml
      end
    end
  end
end

