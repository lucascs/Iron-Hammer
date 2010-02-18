require 'iron_hammer/projects/generic_project'

module IronHammer
  module Projects
    describe GenericProject do
      before :each do
        @project = GenericProject.new :name => 'MyProject'
      end

      it 'should setup the project with the given argument' do
        @project.name.should be_eql('MyProject')
      end

      it 'should not allow the creation of a project without a name' do
        lambda { GenericProject.new }.should raise_error(ArgumentError)
      end

      describe 'creating a package' do
        before :each do
          @project = GenericProject.new :name => 'MyProject'
        end

        it 'should provide a method that sets it up' do
          @project.should respond_to(:package)
        end

        it 'should not fail when given no configuration' do
          @project.should_receive(:deliverables).with({}).and_return(deliverables = [0, 1, 2, 3])
          lambda { @project.package }.should_not raise_error
        end

        it 'should not fail when given a nil configuration' do
          @project.should_receive(:deliverables).with(:configuration => nil).and_return(deliverables = [0, 1, 2, 3])
          lambda { @project.package(:configuration => nil) }.should_not raise_error
        end

        it 'should not fail when given an empty configuration' do
          @project.should_receive(:deliverables).with(:configuration => '').and_return(deliverables = [0, 1, 2, 3])
          lambda { @project.package(:configuration => '') }.should_not raise_error
        end

        it 'should work when given a valid configuration' do
          @project.should_receive(:deliverables).with(:configuration => 'configuration').
            and_return(deliverables = [0, 1, 2, 3])
          package = @project.package(:configuration => 'configuration')
          package.root.should be_eql('delivery')
          package.deliverables.should be_eql(deliverables)
        end
      end

      it 'should get assembly name' do
        file = mock(ProjectFile)
        @project.stub!(:file).and_return file
        file.should_receive(:assembly_name)

        @project.should respond_to :assembly_name

        @project.assembly_name
      end

      it "should list artifacts, but only filenames" do
        @project.stub!(:assembly_name).and_return 'MyProjectArtifact'
        @project.stub!(:path_to_binaries).and_return '/any/path'

        Dir.should_receive('[]').with(File.join('/any/path', 'MyProjectArtifact.{dll,exe}')).and_return(
          ['/any/path/MyProjectArtifact.dll'])

        @project.artifacts.should == ['MyProjectArtifact.dll']
      end

      describe 'dependencies with projects' do
        before :each do
          @file = mock(ProjectFile)
          @project.stub!(:file).and_return @file
        end

        it 'should include dll projects that are dependencies' do
          @file.should_receive(:project_dependencies).and_return ['OtherProject']

          @project.stub!(:dependencies).and_return []

          other = DllProject.new :name => 'OtherProject'
          other.stub!(:assembly_name).and_return 'OtherProject'
          other.stub!(:version).and_return '1.2.3.4'
          other.stub!(:artifacts).and_return ['OtherProject.exe']

          dependencies = @project.dependencies_with_projects [other]

          dependencies.should have(1).dependency
          dependencies.first.should == Dependency.new(
              :name => 'OtherProject', :version => '1.2.3.4', :extension => 'exe')

        end

        it "should include normal dependencies" do
          @file.stub!(:project_dependencies).and_return ['OtherProject']

          normal_dependency = Dependency.new :name => 'NormalDependency'

          @project.stub!(:dependencies).and_return [normal_dependency]

          dependencies = @project.dependencies_with_projects []

          dependencies.should have(1).dependency
          dependencies.first.should == normal_dependency

        end

        it "should only include dependencies" do
          @file.stub!(:project_dependencies).and_return ['OtherProject']
          other = DllProject.new :name => 'Unrelated'

          @project.stub!(:dependencies).and_return []

          dependencies = @project.dependencies_with_projects [other]

          dependencies.should be_empty
        end

        it 'should only include Dll projects' do
          file = mock(ProjectFile)
          @project.stub!(:file).and_return file
          file.stub!(:project_dependencies).and_return ['OtherProject']

          @project.stub!(:dependencies).and_return []

          other = TestProject.new :name => 'OtherProject'

          dependencies = @project.dependencies_with_projects [other]

          dependencies.should be_empty
        end
      end

      it 'should be able to get csproj name' do
        test = GenericProject.new :name => 'MyTest', :csproj => 'MyTestProject.csproj'

        test.csproj.should == 'MyTestProject.csproj'
      end

      describe 'listing dependencies' do
        before :each do
          @project = GenericProject.new :path => 'my_path', :name => 'project_name'
        end

        it 'should load dependencies of the project' do
          project_file = Object.new
          ProjectFile.should_receive(:load_from).with('my_path/project_name.csproj').and_return(project_file)
          project_file.should_receive(:dependencies)
          @project.dependencies
        end

        it 'should load dependencies of the project only on the first time' do
          expected = [Dependency.new(:name => 'anything')]
          project_file = Object.new
          ProjectFile.should_receive(:load_from).with('my_path/project_name.csproj').and_return(project_file)
          project_file.should_receive(:dependencies).and_return(expected)

          @project.dependencies.should be_eql(expected)
          @project.dependencies.should be_eql(expected)
        end
      end

      it "should create an assembly_info" do
        AssemblyInfo.should_receive(:new)

        @project.assembly_info
      end

      it "should use assembly_info to determine version" do
        info = mock(AssemblyInfo)
        @project.stub!(:assembly_info).and_return info
        info.should_receive(:version).and_return "1.2.3.4"

        @project.version.should == "1.2.3.4"
      end

      it "should use assembly_info setter for version" do
        info = mock(AssemblyInfo)
        @project.stub!(:assembly_info).and_return info
        info.should_receive('version=').with("1.2.3.4")

        @project.version = "1.2.3.4"
      end
    end
  end
end

