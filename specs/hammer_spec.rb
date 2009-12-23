require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hammer do

    before :each do
        @fully_set_hammer = Hammer.new @params_for_fully_set_hammer = {
            :project            => @project            = "MyProject",
            :solution           => @solution           = "MySolution",
            :configuration      => @configuration      = "Debug",
            :dot_net_path       => @dot_net_path       = "path/to/.net",
            :test_project       => @test_project       = "TestProject",
            :test_config        => @test_config        = "TestConfig.testrunconfig",
            :test_dll           => @test_dll           = "MyTests.dll",
            :visual_studio_path => @visual_studio_path = "path/to/vs2008" }
        @basic_hammer = Hammer.new :project => @project
    end

    it "should require either a project or solution name" do
        lambda{ Hammer.new }.should(raise_error ArgumentError)
    end

    it "should consider solution and project name to be the same when only one of them is informed" do
        Hammer.new(:project => "MyProject").project.name.should(be_eql "MyProject")
        Hammer.new(:project => "MyProject").solution.name.should(be_eql "MyProject")
        Hammer.new(:solution => "MySolution").solution.name.should(be_eql "MySolution")
        Hammer.new(:solution => "MySolution").project.name.should(be_eql "MySolution")
    end
    
    it "should consider solution and project name to be different when both are informed" do
        hammer = Hammer.new :project => "MyProject", :solution => "MySolution"
        hammer.project.name.should(be_eql "MyProject")
        hammer.solution.name.should(be_eql "MySolution")
    end
    
    it "should consider the test project to assume a default name when its name is not informed" do
        hammer = Hammer.new :project => "MyProject", :solution => "MySolution"
        hammer.test_project.should(be_eql "MyProject.Tests") 
    end
    
    it "should consider the test project to be named as provided" do
        hammer = Hammer.new :test_project => "TestProject", 
            :project => "MyProject", 
            :solution => "MySolution"
        hammer.test_project.should(be_eql "TestProject") 
    end
    
    it "should assume the default configuration when it is not informed" do
        @basic_hammer.configuration.should(be_eql "Release")
    end
    
    it "should assume the provided configuration when it is informed" do
        Hammer.new(:project => "MyProject", :configuration => "conf").configuration.should(
            be_eql "conf")
    end
    
    it "should provide a proper build command line" do
        msbuild = WindowsUtils::patheticalize @dot_net_path, 'msbuild.exe'
    
        @fully_set_hammer.build.should(
            be_eql "#{msbuild} /p:Configuration=#{@configuration} #{@solution}.sln /t:Rebuild")
    end
    
    it "should point to the default testrun config when it is not provided" do
        @basic_hammer.test_config.should(be_eql "LocalTestRun.testrunconfig")
    end
    
    it "should allow the customization of the test configuration" do
        Hammer.new(:project => "MyProject", :test_config => "TestConfig.testrunconfig").
            test_config.should(be_eql "TestConfig.testrunconfig")
    end
    
     it "should point to the default test dll config when it is not provided" do
        @basic_hammer.test_dll.should(be_eql "#{@basic_hammer.test_project}.dll")
    end
    
    it "should allow the customization of the test dll" do
        Hammer.new(:project => "MyProject", :test_dll => "MyTests.dll").
            test_dll.should(be_eql "MyTests.dll")
    end
    
    it "should provide a proper command line to run tests" do
        details = ""
        ["duration", "errorstacktrace", "errormessage", "outcometext"].collect do |detail|
            "/detail:#{detail} "
        end.each do |detail|
            details << detail
        end
        
        test_dll = WindowsUtils::patheticalize @test_project, "bin", @configuration, @test_dll
        results_file = WindowsUtils::patheticalize 'TestResults', 'TestResults.trx'
        mstest = WindowsUtils::patheticalize @visual_studio_path, "mstest.exe"
        
        @fully_set_hammer.test.should(
            be_eql "#{mstest} /testcontainer:#{test_dll} /resultsfile:#{results_file} #{details}")
    end
end