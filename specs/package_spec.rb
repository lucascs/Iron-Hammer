require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Package do
  it "should be succesfully created given a base path" do
    package = Package.new 'path/to/package/root'
  end
  
  it "should allow access to the root folder" do
    package = Package.new 'path/to/package/root'
    package.should respond_to(:root)
    package.root.should be_eql('path/to/package/root')
  end
  
  it "should raise an error if no base path is informed" do
    lambda { Package.new }.should raise_error(ArgumentError)
  end
  
  describe "packaging action" do
    before :each do
      TempHelper::cleanup
      @temp = TempHelper::TempFolder
    end  
  end
end
