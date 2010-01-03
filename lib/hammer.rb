require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/web_project'
require File.dirname(__FILE__) + '/solution'
require File.dirname(__FILE__) + '/test_project'
require File.dirname(__FILE__) + '/dot_net_environment'

class Hammer

    attr_accessor :solution
    attr_accessor :project
    attr_accessor :dot_net_environment
    attr_accessor :test_project
    attr_accessor :configuration
    
    DefaultConfiguration = "Release"

    def initialize params
        @solution           = Solution.new     :name => params[:solution]  || params[:project]
        @project            = WebProject.new   :name => params[:project]   || params[:solution]
        @configuration      = params[:configuration] || DefaultConfiguration
        
        @test_project       = TestProject.new params.merge(
            :name   => params[:test_project],
            :dll    => params[:test_dll],
            :config => params[:test_config])
            
        @dot_net_environment = DotNetEnvironment.new params.merge(
            :framework_path => params[:dot_net_path])
    end

    def details
        ["duration", "errorstacktrace", "errormessage", "outcometext"].inject("") do |buffer, detail|
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

end

