require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/solution'

class Hammer

    attr_accessor :solution
    attr_accessor :project
    attr_accessor :dot_net_environment
    attr_accessor :configuration
    attr_accessor :test_project
    attr_accessor :test_config
    attr_accessor :test_dll
    
    DefaultConfiguration = "Release"
    DefaultTestConfig = "LocalTestRun.testrunconfig"

    def initialize params
        @solution           = Solution.new  :name => params[:solution]  || params[:project]
        @project            = Project.new   :name => params[:project]   || params[:solution]
        @configuration      = params[:configuration]      || DefaultConfiguration
        @test_config        = params[:test_config]        || DefaultTestConfig
        @test_project       = params[:test_project]       || "#{@project.name}.Tests"
        @test_dll           = params[:test_dll]           || "#{@test_project}.dll"
        @dot_net_environment = DotNetEnvironment.new(
            params.merge(:framework_path => params[:dot_net_path]))
    end

    def msbuild
        WindowsUtils::patheticalize(@dot_net_environment.framework_path, 'msbuild.exe')
    end
    
    def mstest
        WindowsUtils::patheticalize(@dot_net_environment.visual_studio_path, 'mstest.exe')
    end
    
    def test_container
        WindowsUtils::patheticalize(@test_project, "bin", @configuration, @test_dll)
    end
    
    def results_file
        WindowsUtils::patheticalize("TestResults", "TestResults.trx")
    end
    
    def details
        ["duration", "errorstacktrace", "errormessage", "outcometext"].inject("") do |base, detail|
            base << "/detail:#{detail} "
        end
    end
    
    def build
        "#{msbuild} /p:Configuration=#{@configuration} #{@solution.solution} /t:Rebuild"
    end
    
    def test
        "#{mstest} /testcontainer:#{test_container} /resultsfile:#{results_file} #{details}"
    end

end

