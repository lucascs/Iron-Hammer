require 'iron_hammer/utils/windows'

module IronHammer
  module Utils
    class DotNetEnvironment
      attr_accessor :framework_path  
      attr_accessor :visual_studio_path  

      def initialize params={}
        @framework_path       = params[:framework_path]     || default_framework_path
        @visual_studio_path   = params[:visual_studio_path] || default_visual_studio_path
      end

      def msbuild
        [@framework_path, 'msbuild.exe'].patheticalize
      end
      
      def mstest
        [@visual_studio_path, 'mstest.exe'].patheticalize
      end
      
      private
      def default_framework_path
        [
          ENV['SystemRoot'] || (IronHammer::Defaults::SYSTEM_ROOT), 
          'Microsoft.NET', 
          'Framework', 
          'v3.5'
        ].patheticalize
      end
      
      def default_visual_studio_path
        [
          ENV['ProgramFiles'] || IronHammer::Defaults::PROGRAM_FILES, 
          'Microsoft Visual Studio 2008', 
          'Common7', 
          'IDE'
        ].patheticalize
      end
    end unless defined? DotNetEnvironment
  end
end
