require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe DllProject do
  before :each do
    @dll_project = DllProject.new :name => 'MyProject'
  end

  it 'should setup the project with the given argument' do
    DllProject.new(:name => 'MyDllProject').name.should be_eql('MyDllProject')
  end
  
  it 'should not allow the creation of a project without a name' do
    lambda { DllProject.new }.should raise_error(ArgumentError)
  end

  it 'should provide a path to the binaries without the need of a configuration' do
    DllProject.new(:name => 'MyDllProject').
      path_to_binaries.should be_eql(File.join('MyDllProject', 'bin', 'Release'))
  end
  
  it 'should provide a path to the binaries given a configuration' do
    @dll_project.should(respond_to :path_to_binaries)
    @dll_project.path_to_binaries(:configuration => 'myConf').should be_eql(File.join('MyProject', 'bin', 'myConf'))
  end
  
  it 'should consider Release as the default configuration when not given a specific one' do
    @dll_project.should(respond_to :path_to_binaries)
    @dll_project.path_to_binaries(:configuration => '').should be_eql(File.join('MyProject', 'bin', 'Release'))
  end
  
  describe 'listing the deliverables' do
    before :each do
      @project = DllProject.new :name => 'MyDllProject'
    end
    
    it 'should be able to list the binaries' do
      @project.should respond_to(:binaries)
      @project.should_receive(:path_to_binaries).with({}).and_return(path_to_binaries = 'foo')
      Dir.should_receive('[]').with(File.join(path_to_binaries, DllProject::BINARIES)).and_return(paths = [
        '/workspace/solution/project/bin/file1.dll',
        'bin/file2.dll',
        'ject/bin/file3.exe',
        'file4.exe'
      ])
      
      binaries = @project.binaries
      binaries.should be_an_instance_of(Array)
      binaries.should have(4).deliverables
      paths.each do |p|
        (binaries.select do |d| 
          d.actual_path == path_to_binaries && 
          d.path_on_package == '' && 
          d.name_on_package == (f = p.split('/').last) && 
          d.actual_name == f
        end).should have(1).matching_element
      end
    end
    
    describe 'regarding configuration files' do
      before :each do
        @project = DllProject.new :name => 'MyDllProject'
      end
    
      it 'should be able to list the ones that are mixed with the binaries' do
        @project.should respond_to(:configuration_files_on_the_binaries_directory)
        @project.should_receive(:path_to_binaries).with({}).and_return(path_to_binaries = 'foo')
        Dir.should_receive('[]').with(File.join(path_to_binaries, DllProject::CONFIGURATION)).and_return(paths = [
          '/workspace/solution/project/bin/file1.config',
          'bin/file2.config',
          'ject/bin/file3.config.xml',
          'file4.config'
        ])
        
        conf_on_bin = @project.configuration_files_on_the_binaries_directory
        conf_on_bin.should be_an_instance_of(Array)
        conf_on_bin.should have(4).deliverables
        paths.each do |p|
          (conf_on_bin.select do |d| 
            d.actual_path == path_to_binaries && 
            d.path_on_package == '' && 
            d.name_on_package == (f = p.split('/').last) && 
            d.actual_name == f
          end).should have(1).matching_element
        end
      end
    
      it 'should be able to list the ones that are lying on the project root directory' do
        @project.should respond_to(:configuration_files_on_the_project_root_directory)
        Dir.should_receive('[]').with(File.join(@project.path, DllProject::CONFIGURATION)).and_return(paths = [
          '/workspace/solution/project/bin/file1.config',
          'bin/file2.config',
          'ject/bin/file3.config.xml',
          'file4.config'
        ])
        
        conf_on_root = @project.configuration_files_on_the_project_root_directory
        conf_on_root.should be_an_instance_of(Array)
        conf_on_root.should have(4).deliverables
        paths.each do |p|
          (conf_on_root.select do |d| 
            d.actual_path == @project.path && 
            d.path_on_package == '' && 
            d.name_on_package == (f = p.split('/').last) && 
            d.actual_name == f
          end).should have(1).matching_element
        end
      end
      
      describe 'for a specific environment' do
        before :each do
          @project = DllProject.new :name => 'MyDllProject'
        end

        it 'should consider the name change for the files mixed with the binaries' do
          @project.should_receive(:path_to_binaries).with(:environment => env = 'production').and_return(path_to_bin = 'bin')
          Dir.should_receive('[]').with(File.join(path_to_bin, DllProject::CONFIGURATION + '.' + env)).
            and_return(paths = [
            '/bin/myConfig.config.production',
            '/bin/myConfig.config.xml.production'
          ])
          
          conf_on_bin = @project.configuration_files_on_the_binaries_directory :environment => env
          conf_on_bin.should be_an_instance_of(Array)
          conf_on_bin.should have(2).deliverables
          paths.each do |p|
            (conf_on_bin.select do |d| 
              d.actual_path == path_to_bin && 
              d.path_on_package == '' && 
              d.actual_name == (f = p.split('/').last) &&
              d.name_on_package == f.sub('.production', '')
            end).should have(1).matching_element
          end
        end
    
        it 'should consider the name change for the files on the root directory' do
          Dir.should_receive('[]').with(File.join(@project.path, DllProject::CONFIGURATION + '.production')).
            and_return(paths = [
            '/root/myConfig.config.production',
            '/root/myConfig.config.xml.production'
          ])
          
          conf_on_root = @project.configuration_files_on_the_project_root_directory :environment => 'production'
          conf_on_root.should be_an_instance_of(Array)
          conf_on_root.should have(2).deliverables
          paths.each do |p|
            (conf_on_root.select do |d| 
              d.actual_path == @project.path && 
              d.path_on_package == '' && 
              d.actual_name == (f = p.split('/').last) &&
              d.name_on_package == f.sub('.production', '')
            end).should have(1).matching_element
          end
        end
      end
    end
  end
end
#    it 'should include the prioritary configuration files' do
#      @project.should_receive(:prioritary_configuration).with(''
#    end

  
#  describe 'listing files for the delivery package' do
#    before :each do 
#      TempHelper::cleanup
#      
#      ['myProject.dll', 'myProject.pdb', 'myProject.foo', 'maiProject.dll', 'maiProject.foo', 'maiProjecto.config',
#        'maiProject.pdb', 'mycon.config', 'maiProject.exe', 'maiProjecto.exe'].each { |file| TempHelper::touch '', file}
#      
#      @temp = TempHelper::TEMP_FOLDER
#      @dll_project = DllProject.new :name => 'MyProject'
#      @dll_project.should_receive(:binaries).with(:configuration => 'release').and_return(@temp)
#      @deliverables = @dll_project.deliverables(:configuration => 'release')
#    end 
#    
#    it 'should return a list' do
#      @deliverables.should_not be_nil
#      @deliverables.should be_an_instance_of(Array)
#      @deliverables.should_not be_empty
#    end
#  
#    it 'should include all *.dll on the list' do
#      @deliverables.should include(Deliverable.create(@temp, 'myProject.dll'))
#      @deliverables.should include(Deliverable.create(@temp, 'maiProject.dll'))
#    end
#    
#    it 'should include all *.exe on the list' do
#      @deliverables.should include(Deliverable.create @temp, 'maiProject.exe')
#      @deliverables.should include(Deliverable.create @temp, 'maiProjecto.exe')
#    end
#    
#    it 'should include all *.config on the list' do
#      @deliverables.should include(Deliverable.create @temp, 'maiProjecto.config')
#      @deliverables.should include(Deliverable.create @temp, 'mycon.config')
#    end
#    
#    it 'should not include anything else on the list' do
#      @deliverables.should_not include(Deliverable.create @temp, 'myProject.pdb')
#      @deliverables.should_not include(Deliverable.create @temp, 'myProject.foo')
#      @deliverables.should_not include(Deliverable.create @temp, 'maiProject.pdb')
#      @deliverables.should_not include(Deliverable.create @temp, 'maiProject.foo')
#    end
#  end

