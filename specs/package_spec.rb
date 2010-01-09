require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Package do
  it 'should allow access to the root folder' do
    package = Package.new :root => 'path/to/package/root', :deliverables => ['a', 'b']
    package.should respond_to(:root)
    package.root.should be_eql('path/to/package/root')
  end
  
  it 'should raise an error if no list of deliverables is given' do
    lambda { Package.new }.should raise_error(ArgumentError)
  end
  
  it 'should raise an error if an empty list of deliverables is given' do
    lambda { Package.new(:deliverables => []) }.should raise_error(ArgumentError)
  end

  it 'should receive a list of deliverables and provide access to it' do
    package = Package.new :deliverables => list = [Deliverable.create 'path', 'file']
    package.should respond_to(:deliverables)
    package.deliverables.should be_eql(list)
  end
  
  describe 'packaging action' do
    before :each do
      TempHelper::cleanup
      
      @package_root = 'package_root' 
      @package = Package.new :root => @package_root.inside_temp_dir, :deliverables => ['a', 'b']
      
      @bin    = @package_root + '/bin'
      @doc    = @package_root + '/doc'
      @config = @package_root + '/config'
      @vi     = @package_root
      
      @binaries       = ['MACSkeptic.Iron.Hammer.dll', 'MACSkeptic.Iron.Hammer.exe']
      @documents      = ['MACSkeptic.Iron.Hammer.txt', 'Readme.txt']
      @configuration  = ['MACSkeptic.Iron.Hammer.config', 'MACSkeptic.Iron.Hammer.exe.config']
      @version_info   = ['Version.info']
      
      @binaries.each { |bin| TempHelper::touch @bin, bin }
      @documents.each { |doc| TempHelper::touch @doc, doc }
      @configuration.each { |config| TempHelper::touch @config, config }
      @version_info.each { |vi| TempHelper::touch @vi, vi }
    end  
    
    it 'should have a package method' do
      @package.should respond_to(:package)
    end
    
    it 'should create a zip with all the contents of the package' do
      expected_zip_package = File.join @package.root, 'package.zip'
      
      @package.package
      
      File.exists?(expected_zip_package).should be_true
      
      Zip::ZipFile::open(expected_zip_package, true) do |zip_file| 
        @binaries.each { |bin| zip_file.find_entry('bin/' + bin).should_not be_nil }
        @documents.each { |doc| zip_file.find_entry('doc/' + doc).should_not be_nil }
        @configuration.each { |config| zip_file.find_entry('config/' + config).should_not be_nil }
        @version_info.each { |vi| zip_file.find_entry(vi).should_not be_nil }
      end
    end
    
    it 'should not screw with the current directory' do
      expected_zip_package = File.join @package.root, 'package.zip'
      
      original_directory = Dir.pwd
      
      @package.package
      
      Dir.pwd.should be_eql(original_directory)
    end
    
    it 'should allow for customization of the package name/path' do
      default_zip_package = File.join @package.root, 'package.zip'
      
      @package.package expected_zip_package = 'customized_package.zip'.inside_temp_dir
      
      File.exists?(default_zip_package).should be_false
      File.exists?(expected_zip_package).should be_true
    end
  end
end
