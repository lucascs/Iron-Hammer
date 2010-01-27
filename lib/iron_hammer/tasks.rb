require 'rubygems'
require 'rake/clean'
require 'iron_hammer'

CLEAN.include("TestResults/**")

namespace :iron do
    task :initialize do
	    @anvil = Anvil.load_solution_from '.'
	    @anvil.load_projects_from_solution
	    @hammer = Hammer.new(defined?(VISUAL_STUDIO_PATH) ? {:visual_studio_path => VISUAL_STUDIO_PATH} : {})
	    FileUtils.mkdir 'TestResults' unless (File.exists?('TestResults') && File.directory?('TestResults'))
    end

    desc 'Builds the solution'
    task :build => [:clean, :initialize] do
	    sh @hammer.build @anvil.solution
    end
    
    namespace :test do
      desc 'Runs the unit tests'
      task :unit => [:build] do
        sh @hammer.test *@anvil.test_projects
      end
    end
end

