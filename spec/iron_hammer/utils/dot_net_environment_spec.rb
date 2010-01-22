require 'iron_hammer/utils/dot_net_environment'

module IronHammer
  module Utils
    describe DotNetEnvironment do
      before :all do
        @basic_environment = DotNetEnvironment.new
      end

      it 'should assume the default path to .net framework when it is not informed' do
        default_path_to_net_framework = [
          ENV['SystemRoot'] || IronHammer::Defaults::SYSTEM_ROOT, 
          'Microsoft.NET', 
          'Framework', 
          'v3.5'
        ].patheticalize
        @basic_environment.framework_path.should be_eql(default_path_to_net_framework)
      end

      it 'should assume the provided path to .net framework when it is informed' do
        DotNetEnvironment.new(:framework_path => 'path').framework_path.should be_eql('path')
      end

      it 'should point to the default path to visual studio tools when none is provided' do
        default_path_to_vs_tools = [
          ENV['ProgramFiles'] || IronHammer::Defaults::PROGRAM_FILES, 
          'Microsoft Visual Studio 2008', 
          'Common7', 
          'IDE'
        ].patheticalize
        @basic_environment.visual_studio_path.should be_eql(default_path_to_vs_tools) 
      end

      it 'should point to the provided path to visual studio tools when it is informed' do
        DotNetEnvironment.new(:visual_studio_path => 'PathToVisual').
          visual_studio_path.should be_eql('PathToVisual') 
      end

      it 'should provide a path to the msbuild binary based on the framework path' do
        path_to_framework = ['path', 'to', 'framework'].patheticalize
        DotNetEnvironment.new(:framework_path => path_to_framework).
          msbuild.should be_eql([path_to_framework, 'msbuild.exe'].patheticalize)
      end

      it 'should provide a path to the mstest binary based on the visual studio path' do
        path_to_vs = ['path', 'to', 'vs'].patheticalize
        DotNetEnvironment.new(:visual_studio_path => path_to_vs).
          mstest.should be_eql([path_to_vs, 'mstest.exe'].patheticalize)
      end
    end
  end
end
