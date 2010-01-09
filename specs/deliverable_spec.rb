require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Deliverable do
  describe "given only an actual file name and path - using create" do
    before :all do
      @deliverable = Deliverable.create @path = 'path/to/deliverable', @name = 'deliverable_name'
    end
  
    it "should provide a method to create a deliverable" do
      @deliverable.actual_name.should be_eql(@name)
      @deliverable.actual_path.should be_eql(@path)
    end
    
    it "should assume that the file will have the same path and name on the package" do
      @deliverable.name_on_package.should be_eql(@name)
      @deliverable.path_on_package.should be_eql(@path)
    end
  end
  
  describe "given only an actual file name and path - using new" do
    before :all do
      @deliverable = Deliverable.new :actual_path => @path = 'path/to/deliverable', 
        :actual_name => @name = 'deliverable_name'
    end
  
    it "should provide a method to create a deliverable" do
      @deliverable.actual_name.should be_eql(@name)
      @deliverable.actual_path.should be_eql(@path)
    end
    
    it "should assume that the file will have the same path and name on the package" do
      @deliverable.name_on_package.should be_eql(@name)
      @deliverable.path_on_package.should be_eql(@path)
    end
  end
  
  describe "given an actual file name and path, plus a name and path for the deliverable on the package" do
    before :all do
      @deliverable = Deliverable.new :actual_path => @path = 'path/to/deliverable', 
        :actual_name => @name = 'deliverable_name',
        :path_on_package => @package_path = 'path/on/package',
        :name_on_package => @package_name = 'name_on_package'
    end
    
    it "should assume all the specific values informed" do
      @deliverable.actual_name.should be_eql(@name)
      @deliverable.actual_path.should be_eql(@path)
      @deliverable.name_on_package.should be_eql(@package_name)
      @deliverable.path_on_package.should be_eql(@package_path)
    end
  end
end
