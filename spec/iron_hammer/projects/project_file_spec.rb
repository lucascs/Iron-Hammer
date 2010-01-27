require 'iron_hammer/projects/project_file'

module IronHammer
  module Projects
    describe ProjectFile do
      it 'should provide a method to parse xml' do 
        ProjectFile.should respond_to(:parse)
      end
      
      it 'should provide a method to directly get the type of a project from a file' do
        ProjectFile.should respond_to(:type_of)
        IronHammer::Utils::FileSystem::should_receive(:read_file).
          with(path = TempHelper::TEMP_FOLDER, name = 'dll.csproj').
          and_return(content = 'content')
        ProjectFile.should_receive(:parse).with(content).and_return(ProjectFile.new :type => DllProject)
        ProjectFile.type_of(path, name).should be_eql(DllProject)
      end
      
      it 'should provide an accessor for the type' do
        ProjectFile.new.should respond_to(:type)
      end
      
      it 'should not be created with a type that is not a class' do
        lambda { ProjectFile.new(:type => 'type')}.should raise_error(ArgumentError)
      end
      
      it 'should be able to parse the xml even if it does not contain guids' do 
        ProjectFile.parse('<xml></xml>').should_not be_nil
      end
      
      it 'should correctly parse asp.net.mvc projects' do
        project_file = ProjectFile.parse(ProjectFileData::asp_net_mvc)
        project_file.should_not be_nil
        project_file.type.should be_eql(AspNetMvcProject)
      end
      
      it 'should correctly parse asp.net projects' do
        project_file = ProjectFile.parse(ProjectFileData::asp_net)
        project_file.should_not be_nil
        project_file.type.should be_eql(AspNetProject)
      end
      
      it 'should correctly parse test projects' do
        project_file = ProjectFile.parse(ProjectFileData::test)
        project_file.should_not be_nil
        project_file.type.should be_eql(TestProject)
      end
      
      it 'should correctly parse dll projects' do
        project_file = ProjectFile.parse(ProjectFileData::dll)
        project_file.should_not be_nil
        project_file.type.should be_eql(DllProject)
      end
      
      it 'should correctly parse wcf projects' do
        project_file = ProjectFile.parse(ProjectFileData::wcf)
        project_file.should_not be_nil
        project_file.type.should be_eql(AspNetProject)
      end
      
      describe 'listing dependencies' do
        before :each do
          @dependencies = ProjectFile.dependencies_of(ProjectFileData::with_dependencies)
        end
        it 'all dependencies must be of type Dependency' do
          @dependencies.should_not be_empty
          @dependencies.each { |d| d.should be_a Dependency }
        end
        
        it 'should contain a specific dependency' do
          found_dependencies = @dependencies.select { |d| d.name == 'manipulacaointerfacearquivos' }
          found_dependencies.size.should == 1
        end
        it 'should contain a specific dependency with version' do
          @dependencies.should include(Dependency.new :name => 'ICSharpCode.SharpZipLib', :version => '0.84.0.0')
        end
      end
    end
  end
end
