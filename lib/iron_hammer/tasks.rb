require 'rubygems'
require 'rake/clean'
require 'iron_hammer'

CLEAN.include("TestResults/**")
CLEAN.include("ivy*.xml")

require 'iron_hammer/tasks/analyze'
require 'iron_hammer/tasks/ivy'
require 'iron_hammer/tasks/test'

namespace :iron do

    @anvil = Anvil.load_from(ENV['SolutionDir'] || '.')
    @hammer = Hammer.new(
      (defined?(VISUAL_STUDIO_PATH) ? {:visual_studio_path => VISUAL_STUDIO_PATH} : {}).merge(
      :configuration => ENV['Configuration']
      ))
    FileUtils.mkdir 'TestResults' unless (File.exists?('TestResults') && File.directory?('TestResults'))

    desc 'Executes the default lifecycle'
    task :default => [:clean, "ivy:retrieve", "ivy:update_version", :build, "test:unit", "ivy:publish"]

    desc 'Builds the solution'
    task :build => [:clean] do
	    sh @hammer.build @anvil.solution
    end

end

