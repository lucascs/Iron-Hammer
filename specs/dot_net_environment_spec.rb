require File.dirname(__FILE__) + '/spec_helper.rb'

describe DotNetEnvironment do
    
    before :each do
        @basic_environment = DotNetEnvironment.new
    end

    it "should assume the default path to .net framework when it is not informed" do
        @basic_environment.framework_path.should(
            be_eql WindowsUtils::patheticalize(
                ENV["SystemRoot"], "Microsoft.NET", "Framework", "v3.5"))
    end
    
    it "should assume the provided path to .net framework when it is informed" do
        DotNetEnvironment.new(:framework_path => "path").framework_path.should(
            be_eql "path")
    end
    
    it "should point to the default path to visual studio tools when none is provided" do
        @basic_environment.visual_studio_path.should(
            be_eql WindowsUtils::patheticalize(
                ENV["ProgramFiles"], "Microsoft Visual Studio 2008", "Common7", "IDE")) 
    end
    
    it "should point to the provided path to visual studio tools when it is informed" do
        DotNetEnvironment.new(:visual_studio_path => "PathToVisual").
            visual_studio_path.should(be_eql "PathToVisual") 
    end
    
    it "should provide a path to the msbuild binary based on the framework path" do
        DotNetEnvironment.new(:framework_path => "path\\to\\framework").msbuild.should(
            be_eql "path\\to\\framework\\msbuild.exe")
    end
    
    it "should provide a path to the mstest binary based on the visual studio path" do
        DotNetEnvironment.new(:visual_studio_path => "path\\to\\vs").mstest.should(
            be_eql "path\\to\\vs\\mstest.exe")
    end
end