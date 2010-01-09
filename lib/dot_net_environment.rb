require File.dirname(__FILE__) + '/windows_utils'

class DotNetEnvironment

    attr_accessor :framework_path  
    attr_accessor :visual_studio_path  

    DEFAULT_FRAMEWORK_PATH    = [ENV["SystemRoot"], "Microsoft.NET", "Framework", "v3.5"].patheticalize
    DEFAULT_VISUAL_STUDIO_PATH = [ENV["ProgramFiles"], "Microsoft Visual Studio 2008", "Common7", "IDE"].patheticalize

    def initialize params={}
        @framework_path       = params[:framework_path]     || DEFAULT_FRAMEWORK_PATH
        @visual_studio_path   = params[:visual_studio_path] || DEFAULT_VISUAL_STUDIO_PATH
    end

    def msbuild
        [@framework_path, 'msbuild.exe'].patheticalize
    end
    
    def mstest
        [@visual_studio_path, 'mstest.exe'].patheticalize
    end
    
end unless defined? DotNetEnvironment
