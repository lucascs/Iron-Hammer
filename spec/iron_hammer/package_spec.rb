require 'iron_hammer/package'

module IronHammer
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
      package = Package.new :deliverables => list = [IronHammer::Deliverables::Deliverable.create('path', 'file')]
      package.should respond_to(:deliverables)
      package.deliverables.should be_eql(list)
    end
    
    describe 'packaging action' do
      before :each do
        TempHelper::cleanup
        
        (@version_info = ['Version.info']).each do |f|
          (@deliverables = []) << IronHammer::Deliverables::Deliverable.new(
            :actual_name => f, 
            :actual_path => (@vi = @original_root = 'original/solution/root').inside_temp_dir, 
            :path_on_package => 'version/info',
            :name_on_package => 'veeeeeersion'
          )
          TempHelper::touch @vi, f
        end
        
        (@binaries = ['MACSkeptic.Iron.Hammer.dll', 'MACSkeptic.Iron.Hammer.exe']).each do |f| 
          @deliverables << IronHammer::Deliverables::Deliverable.new(
            :actual_name => f, 
            :actual_path => (@bin = @original_root + '/bin').inside_temp_dir, 
            :path_on_package => 'bin_bin'
          )
          TempHelper::touch @bin, f 
        end
        
        (@documents = ['MACSkeptic.Iron.Hammer.txt', 'Readme.txt']).each do |f| 
          @deliverables << IronHammer::Deliverables::Deliverable.new(
            :actual_name => f, 
            :actual_path => (@doc = @original_root + '/doc').inside_temp_dir, 
            :path_on_package => 'doc'
          )
          TempHelper::touch @doc, f 
        end
        
        (@configuration = ['MACSkeptic.Iron.Hammer.config', 'MACSkeptic.Iron.Hammer.exe.config']).each do |f| 
          @deliverables << IronHammer::Deliverables::Deliverable.new(
            :actual_name => f, 
            :actual_path => (@config = @original_root + '/config').inside_temp_dir, 
            :path_on_package => 'bin_bin'
          )
          TempHelper::touch @config, f
        end
        
        @package = Package.new :root => (@package_root = 'package_root').inside_temp_dir, :deliverables => @deliverables
      end  
      
      it 'should have a package method' do
        @package.should respond_to('pack!')
      end
      
      it 'should have a zipping method' do
        @package.should respond_to('zip!')
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
        
        @package.pack!.zip!
        
        File.exists?(expected_zip_package).should be_true
        
        Zip::ZipFile::open(expected_zip_package, true) do |zip_file| 
          @deliverables.each do |deliverable| 
            zip_file.find_entry(File.join deliverable.path_on_package, deliverable.name_on_package).should_not be_nil
          end
        end
      end
      
      it 'should not screw with the current directory' do
        IronHammer::Utils::Zipper::should_receive(:zip_current_working_folder_into_this).with('package.zip')
        original_directory = Dir.pwd
        @package.pack!.zip!
        Dir.pwd.should be_eql(original_directory)
      end
      
      it 'should allow for customization of the package name/path' do
        IronHammer::Utils::Zipper::should_receive(:zip_current_working_folder_into_this).
          with('customized_package.zip'.inside_temp_dir)
        @package.pack!.zip! 'customized_package.zip'.inside_temp_dir
      end
    end
  end
end
