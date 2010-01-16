require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe DllProject do
  before :each do
    @project = DllProject.new :name => 'MyProject'
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
    @project.should(respond_to :path_to_binaries)
    @project.path_to_binaries(:configuration => 'myConf').should be_eql(File.join('MyProject', 'bin', 'myConf'))
  end
  
  it 'should consider Release as the default configuration when not given a specific one' do
    @project.should(respond_to :path_to_binaries)
    @project.path_to_binaries(:configuration => '').should be_eql(File.join('MyProject', 'bin', 'Release'))
  end

  describe 'listing the deliverables' do
    describe 'regarding the binaries' do
      it 'should be able to list them (EXEs and DLLs)' do
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
    end
    
    describe 'regarding configuration files' do
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

        it 'should consider the name change for the files on the root directory' do
          Dir.should_receive('[]').with(File.join(@project.path, DllProject::CONFIGURATION + '.production')).
            and_return(paths = [
            '/root/myConfig.config.production',
            '/root/myConfig.config.xml.production'
          ])
          
          conf_on_root = @project.configuration_files_on_the_project_root_directory 'production'
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
      
      it 'should be able to judge the priority of configuration files' do
        @project.should_receive(:configuration_files_on_the_project_root_directory).with('production').
          and_return(files_for_production = [
            file2 = Deliverable.new(
              :actual_name => 'file2.config.production', 
              :actual_path => '/', 
              :name_on_package => 'file2.config'),
            file3 = Deliverable.new(
              :actual_name => 'file3.config.production', 
              :actual_path => '/', 
              :name_on_package => 'file3.config')
        ])
        
        @project.should_receive(:configuration_files_on_the_project_root_directory).with().
          and_return(generic_files = [
            file1 = Deliverable.new(
              :actual_name => 'file1.config', 
              :actual_path => '/',
              :name_on_package => 'file1.config'),
            fail2 = Deliverable.new(
              :actual_name => 'file2.config', 
              :actual_path => '/',
              :name_on_package => 'file2.config')
        ])
        
        configuration = @project.configuration 'production'
        configuration.should be_an_instance_of(Array)
        configuration.should have(3).deliverables
        configuration.should include(file1)
        configuration.should include(file2)
        configuration.should_not include(fail2)
        configuration.should include(file3)
      end
    end
    
    it 'should consider configuration + binaries as deliverables' do
      @project.should respond_to(:deliverables)
      @project.should_receive(:configuration).with('production').and_return(conf = [1, 2, 3])
      @project.should_receive(:binaries).with(:environment => 'production').and_return(bin = [4, 5])
      
      deliverables = @project.deliverables :environment => 'production'
      deliverables.should be_an_instance_of(Array)
      deliverables.should have(5).elements
      deliverables.should include(1)
      deliverables.should include(2)
      deliverables.should include(3)
      deliverables.should include(4)
      deliverables.should include(5)
    end
    
    it 'should assume the default environment when none is passed' do
      @project.should_receive(:configuration).with(Hammer::DEFAULT_ENVIRONMENT).and_return(conf = [1, 2, 3])
      @project.should_receive(:binaries).with({}).and_return(bin = [4, 5])
      
      deliverables = @project.deliverables
      deliverables.should be_an_instance_of(Array)
      deliverables.should have(5).elements
      deliverables.should include(1)
      deliverables.should include(2)
      deliverables.should include(3)
      deliverables.should include(4)
      deliverables.should include(5)
    end
    
    it 'should work even if there are no configurations' do
      @project.should_receive(:configuration).with(Hammer::DEFAULT_ENVIRONMENT).and_return(conf = [])
      @project.should_receive(:binaries).with({}).and_return(bin = [4, 5])
      
      deliverables = @project.deliverables
      deliverables.should be_an_instance_of(Array)
      deliverables.should have(2).elements
      deliverables.should include(4)
      deliverables.should include(5)
    end
    
    it 'should work even if there are no binaries' do
      @project.should_receive(:configuration).with(Hammer::DEFAULT_ENVIRONMENT).and_return(conf = [1, 2, 3])
      @project.should_receive(:binaries).with({}).and_return(bin = [])
      
      deliverables = @project.deliverables
      deliverables.should be_an_instance_of(Array)
      deliverables.should have(3).elements
      deliverables.should include(1)
      deliverables.should include(2)
      deliverables.should include(3)
    end
  end
end

