require 'rubygems'
require 'rake/clean'
require 'iron_hammer'

CLEAN.include("TestResults/**")
CLEAN.include("ivy*.xml")


namespace :iron do
    @anvil = Anvil.load_from '.'
    @hammer = Hammer.new(defined?(VISUAL_STUDIO_PATH) ? {:visual_studio_path => VISUAL_STUDIO_PATH} : {})
    FileUtils.mkdir 'TestResults' unless (File.exists?('TestResults') && File.directory?('TestResults'))

    desc 'Executes the default lifecycle'
    task :default => [:clean, "ivy:retrieve", :build, "test:unit", "ivy:publish"]

    desc 'Builds the solution'
    task :build => [:clean] do
	    sh @hammer.build @anvil.solution
    end

    namespace :test do
      desc 'Runs the unit tests'
      task :unit => [:build] do
        sh @hammer.test *@anvil.test_projects
      end
    end

    namespace :analyze do
      desc 'Analyze the code using fxcop'
      task :fxcop do
        sh @hammer.analyze *@anvil.projects do |ok, response|
          puts response
        end
      end
    end

    namespace :ivy do
      desc 'Publish project dependencies into ivy repository'
      task :setup, [:binaries_path] do |t, args|
        @anvil.projects.each do |project|
          project.dependencies.each do |dependency|
            dependency_project = DependencyProject.new(
                :name => dependency.name,
                :binaries_path => args.binaries_path,
                :version => dependency.version)

            puts "Dependency #{dependency.name}"

            builder = IvyBuilder.new dependency_project

            builder.write_to "ivy-#{dependency.name}.xml"

            sh builder.publish "ivy-#{dependency.name}.xml"
          end
        end
      end

      desc 'Generates ivy-<project_name>.xml for all projects of the solution'
      task :generate do
        puts "Generating ivy files for projects"
        @anvil.projects.each do |project|
          builder = IvyBuilder.new project
          builder.write_to "ivy-#{project.name}.xml"
        end
      end

      desc 'Retrieves all project dependencies from ivy repository and modify project csproj to reference them'
      task :retrieve => [:generate] do
        @anvil.projects.each do |project|
          xml = "ivy-#{project.name}.xml"
          builder = IvyBuilder.new project

          sh builder.retrieve xml

          builder.modify_csproj
        end
      end

      desc 'Publish project assemblies to ivy repository (only dll projects)'
      task :publish => [:generate] do
        @anvil.dll_projects.each do |project|
          xml = "ivy-#{project.name}.xml"
          builder = IvyBuilder.new project

          sh builder.publish xml
        end
      end
    end
end

