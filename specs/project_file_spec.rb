require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe ProjectFile do
  before :each do
    TempHelper::cleanup
  end
  
  it 'should provide a method to parse xml' do 
    ProjectFile.should respond_to(:parse)
  end
  
  it 'should provid an accessor for the type' do
    ProjectFile.new.should respond_to(:type)
  end
  
  it 'should be able to parse the xml even if it does not contain guids' do 
    ProjectFile.parse('<xml></xml>').should_not be_nil
  end
  
  it 'should correctly parse asp.net.mvc projects' do
    project_file = ProjectFile.parse(ProjectFileData::asp_net_mvc)
    project_file.should_not be_nil
    project_file.type.should be_eql(:asp_net_mvc)
  end
  
  it 'should correctly parse asp.net projects' do
    project_file = ProjectFile.parse(ProjectFileData::asp_net)
    project_file.should_not be_nil
    project_file.type.should be_eql(:asp_net)
  end
  
  it 'should correctly parse test projects' do
    project_file = ProjectFile.parse(ProjectFileData::test)
    project_file.should_not be_nil
    project_file.type.should be_eql(:test)
  end
  
  it 'should correctly parse dll projects' do
    project_file = ProjectFile.parse(ProjectFileData::dll)
    project_file.should_not be_nil
    project_file.type.should be_eql(:dll)
  end
end