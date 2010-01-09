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
      @original_root = 'original/solution/root'
      
      
      @bin    = @original_root + '/bin'
      @doc    = @original_root + '/doc'
      @config = @original_root + '/config'
      @vi     = @original_root
      
      @binaries       = ['MACSkeptic.Iron.Hammer.dll', 'MACSkeptic.Iron.Hammer.exe']
      @documents      = ['MACSkeptic.Iron.Hammer.txt', 'Readme.txt']
      @configuration  = ['MACSkeptic.Iron.Hammer.config', 'MACSkeptic.Iron.Hammer.exe.config']
      @version_info   = ['Version.info']
      @deliverables   = []
      
      @binaries.each do |f| 
        @deliverables << Deliverable.new(
          :actual_name => f, 
          :actual_path => @bin.inside_temp_dir, 
          :path_on_package => 'bin_bin'
        )
        TempHelper::touch @bin, f 
      end
      
      @documents.each do |f| 
        @deliverables << Deliverable.new(
          :actual_name => f, 
          :actual_path => @doc.inside_temp_dir, 
          :path_on_package => 'doc'
        )
        TempHelper::touch @doc, f 
      end
      
      @configuration.each do |f| 
        @deliverables << Deliverable.new(
          :actual_name => f, 
          :actual_path => @config.inside_temp_dir, 
          :path_on_package => 'bin_bin'
        )
        TempHelper::touch @config, f
      end
      
      @version_info.each do |f|
        @deliverables << Deliverable.new(
          :actual_name => f, 
          :actual_path => @vi.inside_temp_dir, 
          :path_on_package => 'version/info',
          :name_on_package => 'veeeeeersion'
        )
        TempHelper::touch @vi, f
      end
      
      @package = Package.new :root => @package_root.inside_temp_dir, :deliverables => @deliverables
    end  
    
    it 'should have a package method' do
      @package.should respond_to('pack!')
    end
    
    it 'should move everything to the package root folder, respecting the renamings defined on the deliverables' do
      @package.pack!
      
      package_root = @package_root.inside_temp_dir
      @deliverables.each do |deliverable|
        file = File.join package_root, deliverable.path_on_package, deliverable.name_on_package
        File.exists?(file).should be_true  
      end
    end
    
    it 'should create a zip with all the contents of the package' do
      expected_zip_package = File.join @package.root, 'package.zip'
      
      @package.pack!
      
      File.exists?(expected_zip_package).should be_true
      
      Zip::ZipFile::open(expected_zip_package, true) do |zip_file| 
        @deliverables.each do |deliverable| 
          zip_file.find_entry(File.join deliverable.path_on_package, deliverable.name_on_package).should_not be_nil
        end
      end
    end
    
    it 'should not screw with the current directory' do
      expected_zip_package = File.join @package.root, 'package.zip'
      
      original_directory = Dir.pwd
      
      @package.pack!
      
      Dir.pwd.should be_eql(original_directory)
    end
    
    it 'should allow for customization of the package name/path' do
      default_zip_package = File.join @package.root, 'package.zip'
      
      @package.pack! expected_zip_package = 'customized_package.zip'.inside_temp_dir
      
      File.exists?(default_zip_package).should be_false
      File.exists?(expected_zip_package).should be_true
    end
  end
end
