require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe ProjectFile do
  it 'should provide a method to parse xml' do 
    ProjectFile.should respond_to(:parse)
  end
  
  it 'should provide a method to directly get the type of a project from a file' do
    ProjectFile.should respond_to(:type_of)
    TheFiler::should_receive(:read_file).
      with(path = TempHelper::TEMP_FOLDER, name = 'dll.csproj').
      and_return(content = 'content')
    ProjectFile.should_receive(:parse).with(content).and_return(ProjectFile.new :type => :dll)
    ProjectFile.type_of(path, name).should be_eql(:dll)
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
  
  it 'should correctly parse wcf projects' do
    project_file = ProjectFile.parse(ProjectFileData::wcf)
    project_file.should_not be_nil
    project_file.type.should be_eql(:asp_net)
  end
end
