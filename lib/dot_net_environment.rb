require File.dirname(__FILE__) + '/windows_utils'

class DotNetEnvironment

    attr_accessor :framework_path  
    attr_accessor :visual_studio_path  

    DefaultFrameworkPath    = WindowsUtils::patheticalize(
        ENV["SystemRoot"], "Microsoft.NET", "Framework", "v3.5")
    DefaultVisualStudioPath = WindowsUtils::patheticalize(
        ENV["ProgramFiles"], "Microsoft Visual Studio 2008", "Common7", "IDE")

    def initialize params={}
        @framework_path       = params[:framework_path]     || DefaultFrameworkPath
        @visual_studio_path   = params[:visual_studio_path] || DefaultVisualStudioPath
    end

    def msbuild
        WindowsUtils::patheticalize(@framework_path, 'msbuild.exe')
    end
    
    def mstest
        WindowsUtils::patheticalize(@visual_studio_path, 'mstest.exe')
    end
    
end