require 'iron_hammer/windows_utils'
require 'iron_hammer/projects/generic_project'
require 'iron_hammer/solution'
require 'iron_hammer/test_project'
require 'iron_hammer/dot_net_environment'

module IronHammer
  class Hammer
    attr_accessor :solution
    attr_accessor :project
    attr_accessor :dot_net_environment
    attr_accessor :test_project
    attr_accessor :configuration
    
    DEFAULT_CONFIGURATION = 'Release'
    DEFAULT_ENVIRONMENT = 'local'

    def initialize params={}
      @solution       = Solution.new  :name => params[:solution]  || params[:project]
      @project        = GenericProject.new   :name => params[:project]   || params[:solution]
      @configuration  = params[:configuration] || DEFAULT_CONFIGURATION
      
      @test_project   = TestProject.new params.merge(
        :name   => params[:test_project],
        :dll    => params[:test_dll],
        :config => params[:test_config])
        
      @dot_net_environment = DotNetEnvironment.new params.merge(
        :framework_path => params[:dot_net_path])
    end

    def details
      ['duration', 'errorstacktrace', 'errormessage', 'outcometext'].inject('') do |buffer, detail|
        buffer << "/detail:#{detail} "
      end
    end
    
    def build
      msbuild       = @dot_net_environment.msbuild 
      configuration = @configuration
      solution      = @solution.solution
      "#{msbuild} /p:Configuration=#{configuration} #{solution} /t:Rebuild"
    end
    
    def test
      container = @test_project.container @configuration
      results   = @test_project.results_file
      mstest    = @dot_net_environment.mstest
      "#{mstest} /testcontainer:#{container} /resultsfile:#{results} #{details}"
    end

  end unless defined? Hammer
end

