require 'rubygems'
require 'rake/clean'
require 'iron_hammer'

CLEAN.include("TestResults/**")
CLEAN.include("ivy*.xml")


namespace :iron do

    @anvil = Anvil.load_from(ENV['SolutionDir'] || '.')
    @hammer = Hammer.new(
      (defined?(VISUAL_STUDIO_PATH) ? {:visual_studio_path => VISUAL_STUDIO_PATH} : {}).merge(
      :configuration => ENV['Configuration']
      ))
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
        command = @hammer.test *@anvil.unit_test_projects
        puts "There are no unit tests to run" unless command
        sh command if command
      end

      desc 'Runs the integration tests'
      task :integration => [:build] do
        command = @hammer.test *@anvil.integration_test_projects
        puts "There are no integration tests to run" unless command
        sh command if command
      end
    end

    namespace :analyze do
      desc 'Analyzes the code using fxcop'
      task :fxcop do
        sh @hammer.analyze *@anvil.projects do |ok, response|
          puts response
        end
      end
    end

    namespace :ivy do
      desc 'Publishes project dependencies into ivy repository'
      task :setup, [:binaries_path] do |t, args|
        all_dependencies = []
        @anvil.projects.each do |project|
          project.dependencies.each do |dependency|
            all_dependencies << dependency unless all_dependencies.include? dependency
          end
        end

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

              builder = IvyBuilder.new dependency_project

              builder.write_to "ivy-#{dependency.name}.xml"

              sh builder.publish "ivy-#{dependency.name}.xml"
            end
          end
        end
      end

      desc 'Generates ivy-<project_name>.xml for all projects of the solution'
      task :generate => :update_version do
        puts "Generating ivy files for projects"
        @anvil.projects.each do |project|
          builder = IvyBuilder.new project
          builder.write_to "ivy-#{project.name}.xml"
        end
      end

      desc 'updates version of AssemblyInfo based on build_number environment variable'
      task :update_version do
        @anvil.projects.each do |project|
          old_version = project.version
          project.version = old_version.gsub /\.\d+$/, ".#{build_number}"
        end
      end

      def build_number
        ENV['BUILD_NUMBER'] || '0'
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

      desc 'Publishes project assemblies to ivy repository (only dll projects)'
      task :publish => [:generate] do
        @anvil.dll_projects.each do |project|
          xml = "ivy-#{project.name}.xml"
          builder = IvyBuilder.new project

          sh builder.publish xml
        end
      end
    end
end

