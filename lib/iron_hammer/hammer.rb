require 'iron_hammer/utils/windows'
require 'iron_hammer/projects/generic_project'
require 'iron_hammer/solutions/solution'
require 'iron_hammer/projects/test_project'
require 'iron_hammer/utils/dot_net_environment'

module IronHammer
  class Hammer
    attr_accessor :solution
    attr_accessor :project
    attr_accessor :dot_net_environment
    attr_accessor :test_project
    attr_accessor :configuration
    
    def initialize params={}
      @solution       = IronHammer::Solutions::Solution.new  :name => params[:solution]  || params[:project]
      @project        = IronHammer::Projects::GenericProject.new   :name => params[:project]   || params[:solution]
      @configuration  = params[:configuration] || IronHammer::Defaults::CONFIGURATION_RUN
      
      @test_project   = IronHammer::Projects::TestProject.new params.merge(
        :name   => params[:test_project],
        :dll    => params[:test_dll],
        :config => params[:test_config])
        
      @dot_net_environment = IronHammer::Utils::DotNetEnvironment.new params.merge(
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

