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
      
      @package_root = 'package_root' 
      @package = Package.new @package_root.inside_temp_dir
      
      @bin = @package_root + '/bin'
      @doc = @package_root + '/doc'
      @config = @package_root + '/config'
      
      @binaries = ['MACSkeptic.Iron.Hammer.dll', 'MACSkeptic.Iron.Hammer.exe']
      @documents = ['MACSkeptic.Iron.Hammer.txt', 'Readme.txt']
      @configuration = ['MACSkeptic.Iron.Hammer.config', 'MACSkeptic.Iron.Hammer.exe.config']
      @version_info = ['Version.info']
      
      @binaries.each { |bin| TempHelper::touch @bin, bin }
      @documents.each { |doc| TempHelper::touch @doc, doc }
      @configuration.each { |config| TempHelper::touch @config, config }
      @version_info.each { |vi| TempHelper::touch '', vi }
    end  
    
    it "should have a package method" do
      @package.should respond_to(:package)
    end
    
    it "should create a zip with all the contents of the package" do
    end
  end
end
