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
end
