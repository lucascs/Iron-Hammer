require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe SolutionFile do
  before :each do
    TempHelper::cleanup
    TheFiler::write!(
      TempHelper::TEMP_FOLDER, 
      @solution_file_name = 'my.sln', 
      @solution_file_content = SolutionFileData::multiproject
    )
  end
  
  it 'should be able to read the solution file, creating a hash of projects' do
    projects = SolutionFile.parse TheFiler::read_lines(TempHelper::TEMP_FOLDER, @solution_file_name)
    projects.should have(2).elements
    projects.should include(:name => 'Matchers', :path => 'Matchers', :csproj => 'Matchers.csproj')
    projects.should include(:name => 'Tests', :path => 'Tests', :csproj => 'Tests.csproj')
  end

end
