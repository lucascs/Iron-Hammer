class TestProject

    attr_accessor :config
    attr_accessor :dll
    attr_accessor :name
    
    DefaultTestConfig = "LocalTestRun.testrunconfig"
    
    def initialize params
        @name   = params[:name]     || "#{ params[:project] || params[:solution] }.Tests"
        @dll    = "#{ params[:dll]  || @name}.dll"
        @config = params[:config]   || DefaultTestConfig
    end

    def container configuration
        WindowsUtils::patheticalize(@name, "bin", configuration, @dll)
    end
    
    def results_file
        WindowsUtils::patheticalize("TestResults", "TestResults.trx")
    end
    
end