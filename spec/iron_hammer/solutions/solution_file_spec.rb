require 'iron_hammer/solutions/solution_file'

module IronHammer
  module Solutions
    describe SolutionFile do
      before :each do
        TempHelper::cleanup
        IronHammer::Utils::FileSystem::write!(
          :path => TempHelper::TEMP_FOLDER,
          :name => @solution_file_name = 'my.sln',
          :content => @solution_file_content = SolutionFileData::multiproject
        )
      end

      it 'should be able to read the solution file, creating a hash of projects' do
        SolutionFile.should respond_to(:parse)
        solution_file = SolutionFile.parse IronHammer::Utils::FileSystem::read_lines(
          TempHelper::TEMP_FOLDER, @solution_file_name)
        solution_file.should respond_to(:projects)
        projects = solution_file.projects
        projects.should have(2).elements
        projects.should include(:name => 'Matchers', :path => 'Matchers', :csproj => 'Matchers.csproj')
        projects.should include(:name => 'Tests', :path => 'Tests', :csproj => 'Tests.csproj')
      end

      it 'should ignore non csproj projects' do
        solution_file = SolutionFile.parse SolutionFileData.with_installer

        projects = solution_file.projects
        projects.should have(2).elements
        projects.should include(:name => 'Matchers', :path => 'Matchers', :csproj => 'Matchers.csproj')
        projects.should include(:name => 'Tests', :path => 'Tests', :csproj => 'Tests.csproj')
      end
    end
  end
end

