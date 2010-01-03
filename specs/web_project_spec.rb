require File.dirname(__FILE__) + '/spec_helper.rb'

describe WebProject do

    it "should setup the project with the given argument" do
        WebProject.new(:name => "MyWebProject").name.should(be_eql "MyWebProject")
    end
    
    it "should not allow the creation of a project without a name" do
        lambda { WebProject.new }.should(raise_error ArgumentError)
    end

    it "should provide a path to the binaries without the need of a configuration" do
        WebProject.new(:name => "MyWebProject").path_to_binaries.should(
            be_eql ["MyWebProject", "bin"].patheticalize)
    end
    
end