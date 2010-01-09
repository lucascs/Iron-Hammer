require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Project do
  before :each do
    @project = Project.new :name => 'MyProject'
  end
  
  it 'should setup the project with the given argument' do
    @project.name.should be_eql('MyProject')
  end
  
  it 'should not allow the creation of a project without a name' do
    lambda { Project.new }.should raise_error(ArgumentError)
  end

  it 'should provide a path to the binaries given a configuration' do
    @project.should(respond_to :path_to_binaries)
    @project.path_to_binaries('myConf').should be_eql(['MyProject', 'bin', 'myConf'].patheticalize)
  end
  
  it 'should not provide a path to the binaries given an empty configuration' do
    @project.should(respond_to :path_to_binaries)
    lambda { @project.path_to_binaries('') }.should raise_error(ArgumentError)
  end
  
  it 'should provide a path to the delivery package directory' do 
    @project.should(respond_to :path_to_delivery_directory)
    @project.path_to_delivery_directory.should be_eql('delivery')
  end
  
  describe 'when listing files for the delivery package' do
    before :all do 
      TempHelper::cleanup
      
      ['myProject.dll', 'myProject.pdb', 'myProject.foo', 'maiProject.dll', 'maiProject.foo', 'maiProjecto.config',
        'maiProject.pdb', 'mycon.config', 'maiProject.exe', 'maiProjecto.exe'].each { |file| TempHelper::touch '', file}
      
      @temp = TempHelper::TEMP_FOLDER
      @project = Project.new :name => 'MyProject'
      @project.should_receive(:path_to_binaries).with('release').and_return(@temp)
      @files_to_deliver = @project.files_to_deliver('release')
    end 
    
    it 'should return a list' do
      @files_to_deliver.should_not be_nil
      @files_to_deliver.should be_an_instance_of(Array)
      @files_to_deliver.should_not be_empty
    end
  
    it 'should include all *.dll on the list' do
      @files_to_deliver.should include(Deliverable.create @temp, 'myProject.dll')
      @files_to_deliver.should include(Deliverable.create @temp, 'maiProject.dll')
    end
    
    it 'should include all *.exe on the list' do
      @files_to_deliver.should include(Deliverable.create @temp, 'maiProject.exe')
      @files_to_deliver.should include(Deliverable.create @temp, 'maiProjecto.exe')
    end
    
    it 'should include all *.config on the list' do
      @files_to_deliver.should include(Deliverable.create @temp, 'maiProjecto.config')
      @files_to_deliver.should include(Deliverable.create @temp, 'mycon.config')
    end
    
    it 'should not include anything else on the list' do
      @files_to_deliver.should_not include(Deliverable.create @temp, 'myProject.pdb')
      @files_to_deliver.should_not include(Deliverable.create @temp, 'myProject.foo')
      @files_to_deliver.should_not include(Deliverable.create @temp, 'maiProject.pdb')
      @files_to_deliver.should_not include(Deliverable.create @temp, 'maiProject.foo')
    end
  end
end
