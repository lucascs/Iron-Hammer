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
  
  it 'should consider Release as the default configuration when not given a specific one' do
    @project.should(respond_to :path_to_binaries)
    @project.path_to_binaries('').should be_eql(['MyProject', 'bin', 'Release'].patheticalize)
  end
  
  describe 'when listing files for the delivery package' do
    before :each do 
      TempHelper::cleanup
      
      ['myProject.dll', 'myProject.pdb', 'myProject.foo', 'maiProject.dll', 'maiProject.foo', 'maiProjecto.config',
        'maiProject.pdb', 'mycon.config', 'maiProject.exe', 'maiProjecto.exe'].each { |file| TempHelper::touch '', file}
      
      @temp = TempHelper::TEMP_FOLDER
      @project = Project.new :name => 'MyProject'
      @project.should_receive(:path_to_binaries).with('release').and_return(@temp)
      @deliverables = @project.deliverables('release')
    end 
    
    it 'should return a list' do
      @deliverables.should_not be_nil
      @deliverables.should be_an_instance_of(Array)
      @deliverables.should_not be_empty
    end
  
    it 'should include all *.dll on the list' do
      @deliverables.should include(Deliverable.create @temp, 'myProject.dll')
      @deliverables.should include(Deliverable.create @temp, 'maiProject.dll')
    end
    
    it 'should include all *.exe on the list' do
      @deliverables.should include(Deliverable.create @temp, 'maiProject.exe')
      @deliverables.should include(Deliverable.create @temp, 'maiProjecto.exe')
    end
    
    it 'should include all *.config on the list' do
      @deliverables.should include(Deliverable.create @temp, 'maiProjecto.config')
      @deliverables.should include(Deliverable.create @temp, 'mycon.config')
    end
    
    it 'should not include anything else on the list' do
      @deliverables.should_not include(Deliverable.create @temp, 'myProject.pdb')
      @deliverables.should_not include(Deliverable.create @temp, 'myProject.foo')
      @deliverables.should_not include(Deliverable.create @temp, 'maiProject.pdb')
      @deliverables.should_not include(Deliverable.create @temp, 'maiProject.foo')
    end
  end
  
  describe 'creating a package' do
    before :each do 
      @project = Project.new :name => 'MyProject'
    end
    
    it 'should provide a method that sets it up' do
      @project.should respond_to(:package)
    end
    
    it 'should not fail when given no configuration' do
      @project.should_receive(:deliverables).with(nil).and_return(deliverables = [0, 1, 2, 3])
      lambda { @project.package }.should_not raise_error
    end
    
    it 'should not fail when given a nil configuration' do
      @project.should_receive(:deliverables).with(nil).and_return(deliverables = [0, 1, 2, 3])
      lambda { @project.package(:configuration => nil) }.should_not raise_error
    end
    
    it 'should not fail when given an empty configuration' do
      @project.should_receive(:deliverables).with('').and_return(deliverables = [0, 1, 2, 3])
      lambda { @project.package(:configuration => '') }.should_not raise_error
    end
    
    it 'should work when given a valid configuration' do
      @project.should_receive(:deliverables).with('configuration').and_return(deliverables = [0, 1, 2, 3])
      package = @project.package(:configuration => 'configuration')
      package.root.should be_eql('delivery')
      package.deliverables.should be_eql(deliverables)
    end 
  end
end
