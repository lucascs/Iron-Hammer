class Hammer

    attr_accessor :dot_net_path
    attr_accessor :project
    attr_accessor :solution
    attr_accessor :configuration
    attr_accessor :test_project
    attr_accessor :test_config
    attr_accessor :test_dll
    attr_accessor :visual_studio_path
    
    DefaultDotNetPath = File.join(
        ENV["SystemRoot"], "Microsoft.NET", "Framework", "v3.5")
    DefaultVisualStudioPath = File.join(
        ENV["ProgramFiles"], "Microsoft Visual Studio 2008", "Common7", "IDE")
    DefaultConfiguration = "Release"
    DefaultTestConfig = "LocalTestRun.testrunconfig"

    def initialize params
        @project            = params[:project]            || params[:solution]    || 
            raise(ArgumentError.new "must provide either a project or solution name")
        @solution           = params[:solution]           || params[:project]     || 
            raise(ArgumentError.new "must provide either a project or solution name")
        @dot_net_path       = params[:dot_net_path]       || DefaultDotNetPath
        @configuration      = params[:configuration]      || DefaultConfiguration
        
        @test_project       = params[:test_project]       || "#{@project}.Tests"
        @test_config        = params[:test_config]        || DefaultTestConfig
        @test_dll           = params[:test_dll]           || "#{@test_project}.dll"
        @visual_studio_path = params[:visual_studio_path] || DefaultVisualStudioPath
        @solution = "#{@solution}.sln"
    end

    def msbuild
        File.join(@dot_net_path, 'msbuild.exe')
    end
    
    def mstest
        File.join(@visual_studio_path, 'mstest.exe')
    end
    
    def test_container
        File.join(@test_project, "bin", @configuration, @test_dll)
    end
    
    def results_file
        File.join("TestResults", "TestResults.trx")
    end
    
    def details
        ["duration", "errorstacktrace", "errormessage", "outcometext"].inject("") do |base, detail|
            base << "/detail:#{detail} "
        end
    end
    
    def build
        "#{msbuild} /p:Configuration=#{@configuration} #{@solution} /t:Rebuild"
    end
    
    def test
        "#{mstest} /testcontainer:#{test_container} /resultsfile:#{results_file} #{details}"
    end

end

