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

    @options = {}
    @options[:visual_studio_path] = VISUAL_STUDIO_PATH  if defined?(VISUAL_STUDIO_PATH)
    @options[:dot_net_path]       = DOT_NET_PATH        if defined?(DOT_NET_PATH)
    @options[:fxcop_path]         = FXCOP_PATH          if defined?(FXCOP_PATH)
    @options[:configuration]      = ENV['Configuration']

    @hammer = Hammer.new @options

    FileUtils.mkdir 'TestResults' unless (File.exists?('TestResults') && File.directory?('TestResults'))

    desc 'Executes the default lifecycle'
    task :default => [:clean, "ivy:retrieve", "ivy:update_version", :build, "test:unit", "ivy:publish"]

    desc 'Builds the solution'
    task :build => [:clean] do
	    sh @hammer.build @anvil.solution
    end

end

