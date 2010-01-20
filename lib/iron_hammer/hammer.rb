require 'iron_hammer/utils/windows'
require 'iron_hammer/projects/test_project'
require 'iron_hammer/solutions/solution'
require 'iron_hammer/utils/dot_net_environment'

module IronHammer
  class Hammer
    attr_accessor :dot_net_environment
    attr_accessor :configuration
    
    def initialize params={}
      @configuration  = params[:configuration] || IronHammer::Defaults::CONFIGURATION_RUN
      @dot_net_environment = IronHammer::Utils::DotNetEnvironment.new params.merge(
        :framework_path => params[:dot_net_path])
    end

    def details
      ['duration', 'errorstacktrace', 'errormessage', 'outcometext'].inject('') do |buffer, detail|
        buffer << "/detail:#{detail} "
      end
    end
    
    def build solution
      msbuild       = @dot_net_environment.msbuild 
      configuration = @configuration
      solution      = solution.solution
      "#{msbuild} /p:Configuration=#{configuration} #{solution} /t:Rebuild"
    end
    
    def test project
      container = project.container @configuration
      results   = project.results_file
      mstest    = @dot_net_environment.mstest
      "#{mstest} /testcontainer:#{container} /resultsfile:#{results} #{details}"
    end

  end unless defined? Hammer
end

