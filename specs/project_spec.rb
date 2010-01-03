require File.dirname(__FILE__) + '/helpers/spec_helper.rb'

describe Project do

    it "should setup the project with the given argument" do
        Project.new(:name => "MyProject").name.should(be_eql "MyProject")
    end
    
    it "should not allow the creation of a project without a name" do
        lambda { Project.new }.should(raise_error ArgumentError)
    end

    it "should provide a path to the binaries given a configuration" do
        Project.new(:name => "MyProject").path_to_binaries("myConf").should(
            be_eql ["MyProject", "bin", "myConf"].patheticalize)
    end
    
    it "should not provide a path to the binaries given an empty configuration" do
        lambda { Project.new(:name => "MyProject").path_to_binaries("") }.should(
            raise_error ArgumentError)
    end
    
    it "should provide a list of every single file that will be packaged for delivery" do
    end
end