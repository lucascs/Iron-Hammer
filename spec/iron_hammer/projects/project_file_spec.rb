require 'iron_hammer/projects/project_file'

module IronHammer
  module Projects
    describe ProjectFile do
      it 'should provide a method to load from a csproj' do
        ProjectFile.should respond_to(:load_from)
      end

      it 'should provide an accessor for the type' do
        ProjectFile.instance_methods.collect {|m| m.to_sym }.should include(:type)
      end

      it 'should be able to parse the xml even if it does not contain guids (it should be considered a DLL)' do
        project_file = ProjectFile.load_from path = 'path/to/project.csproj'
        project_file.should_receive(:xml).and_return('<xml></xml>')
        project_file.type.should be_eql(DllProject)
      end

      it 'should correctly parse asp.net.mvc projects' do
        project_file = ProjectFile.load_from path = 'path/to/project.csproj'
        project_file.should_receive(:xml).and_return(ProjectFileData::asp_net_mvc)
        project_file.should_not be_nil
        project_file.type.should be_eql(AspNetMvcProject)
      end

      it 'should correctly parse asp.net projects' do
        project_file = ProjectFile.load_from path = 'path/to/project.csproj'
        project_file.should_receive(:xml).and_return(ProjectFileData::asp_net)
        project_file.should_not be_nil
        project_file.type.should be_eql(AspNetProject)
      end

      it 'should correctly parse test projects' do
        project_file = ProjectFile.load_from path = 'path/to/project.csproj'
        project_file.should_receive(:xml).and_return(ProjectFileData::test)
        project_file.should_not be_nil
        project_file.type.should be_eql(TestProject)
      end

      it 'should correctly parse dll projects' do
        project_file = ProjectFile.load_from path = 'path/to/project.csproj'
        project_file.should_receive(:xml).and_return(ProjectFileData::dll)
        project_file.should_not be_nil
        project_file.type.should be_eql(DllProject)
      end

      it 'should correctly parse wcf projects' do
        project_file = ProjectFile.load_from path = 'path/to/project.csproj'
        project_file.should_receive(:xml).and_return(ProjectFileData::wcf)
        project_file.should_not be_nil
        project_file.type.should be_eql(AspNetProject)
      end

      it 'should be able to return the assembly name of the project' do
        project_file = ProjectFile.load_from path = 'path/to/project.csproj'
        project_file.should_receive(:xml).and_return(ProjectFileData::dll)

        project_file.should respond_to(:assembly_name)

        project_file.assembly_name.should == 'Codevil.MACSkeptic.TestingWithCSharp.BankSystem'
      end

      describe 'listing dependencies' do
        before :each do
          @project_file = ProjectFile.load_from path = 'path/to/project.csproj'
          @project_file.should_receive(:xml).and_return(ProjectFileData::with_dependencies)
          @dependencies = @project_file.dependencies
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

        it 'should contain a project dependencies' do
          project_dependencies = @project_file.project_dependencies
          project_dependencies.should include('LibProvisioning')
        end

        it 'should not contain system dependencies' do
          @dependencies.should_not contain_system_dependencies
        end

        def contain_system_dependencies
          simple_matcher("contain system dependencies") {|ds| ds.find {|d| d.name.starts_with 'System'}}
        end
      end
    end
  end
end

