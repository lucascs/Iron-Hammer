require 'iron_hammer/utils/ivy_builder'
require 'iron_hammer/utils/ivy_configuration'
require 'rexml/document'

module IronHammer
  module Utils
    describe IvyBuilder do
      it "should build a xml for a basic project" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:assembly_name).and_return "MyProjectArtifact"
        @ivy = IvyConfiguration.builder_for project

        xml = @ivy.to_s
        xml.should match /<info .*\/>/
        xml.should match /organisation="org"/
        xml.should match /module="MyProjectArtifact"/
      end

      it "should add binaries as artifacts" do
        project = DllProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:assembly_name).and_return 'MyProject'
        project.stub!(:artifacts).and_return ["My.Project.Artifact.dll"]

        @ivy = IvyConfiguration.builder_for project

        xml = @ivy.to_s
        xml.should match /<publications>.*<\/publications>/ms
        xml.should match /<artifact .*\/>/
        xml.should match /name="My.Project.Artifact"/
        xml.should match /type="dll"/
      end

      it "should include project dependencies" do
        project = mock(GenericProject)
        project.stub!(:name).and_return "MyProject"
        project.stub!(:dependencies).and_return [Dependency.new(:name => "My Dependency", :version => "1.2.3.4")]
        project.stub!(:assembly_name).and_return "MyProjectArtifact"

        @ivy = IvyConfiguration.builder_for project

        xml = @ivy.to_s
        xml.should match /<dependencies>.*<\/dependencies>/ms
        xml.should match /<dependency .*>.*<\/dependency>/ms
        xml.should match /org="org"/
        xml.should match /name="My Dependency"/
        xml.should match /rev="1\.2\.3\.\+"/
      end

      it "should include project dependencies with specific version" do
        project = mock(GenericProject)
        project.stub!(:name).and_return "MyProject"
        project.stub!(:dependencies).and_return [Dependency.new(:name => "My Dependency", :version => "1.2.3.4", :specific => true)]
        project.stub!(:assembly_name).and_return "MyProjectArtifact"

        @ivy = IvyConfiguration.builder_for project

        xml = @ivy.to_s
        xml.should match /<dependencies>.*<\/dependencies>/ms
        xml.should match /<dependency .*>.*<\/dependency>/ms
        xml.should match /org="org"/
        xml.should match /name="My Dependency"/
        xml.should match /rev="1\.2\.3\.4"/
      end

      it "should include correct revision pattern" do
        project = mock(GenericProject)
        project.stub!(:name).and_return "MyProject"
        project.stub!(:dependencies).and_return [Dependency.new(:name => "My Dependency", :version => "1.2.3.4")]
        project.stub!(:assembly_name).and_return "MyProjectArtifact"

        config = IvyConfiguration.instance
        @ivy = IvyBuilder.new :config => config, :project => project

        config.retrieve_version = 'latest'
        @ivy.to_s.should match /rev="\+"/
        config.retrieve_version = 'latest.major'
        @ivy.to_s.should match /rev="\+"/
        config.retrieve_version = 'latest.minor'
        @ivy.to_s.should match /rev="1\.\+"/
        config.retrieve_version = 'latest.revision'
        @ivy.to_s.should match /rev="1\.2\.\+"/
        config.retrieve_version = 'latest.build'
        @ivy.to_s.should match /rev="1\.2\.3\.\+"/
        config.retrieve_version = 'specific'
        @ivy.to_s.should match /rev="1\.2\.3\.4"/
      end

      it "should include project dependencies artifact" do
        project = mock(GenericProject)
        project.stub!(:name).and_return "MyProject"
        project.stub!(:dependencies).and_return [Dependency.new(:name => "My Dependency", :version => "1.2.3", :extension => "exe")]
        project.stub!(:assembly_name).and_return "MyProjectArtifact"

        @ivy = IvyConfiguration.builder_for project

        xml = @ivy.to_s
        xml.should match /<artifact .*type="exe".*\/>/
      end

      it "should write the xml to a file" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:assembly_name).and_return "MyProjectArtifact"
        @ivy = IvyConfiguration.builder_for project

        file = "#{TempHelper::TEMP_FOLDER}/ivy.xml"
        @ivy.write_to file
        xml = File.read(file)
        xml.should match /<info .*\/>/
        xml.should match /organisation="org"/
        xml.should match /module="MyProjectArtifact"/
      end

      it "should generate retrieve command" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        @ivy = IvyConfiguration.builder_for project

        command = @ivy.retrieve "ivy.xml"

        command.should match /-ivy ivy.xml/
        command.should match /-retrieve/
      end

      it "should generate publish command, including binaries path" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:path_to_binaries).and_return "binaries/here"
        project.stub!(:version).and_return '1.0.0.0'
        @ivy = IvyConfiguration.builder_for project

        command = @ivy.publish "ivy.xml"

        command.should match /-ivy ivy.xml/
        command.should match /-publish/
        command.should match /-publishpattern binaries\/here\/\[artifact\].\[ext\]/
        command.should match /-revision/
      end

      describe "modifying csproj" do
        before :each do
          @dir = 'temp'
          @project = GenericProject.new :path => @dir, :csproj => 'abc.csproj', :name => 'abc'

          FileSystem.write! :name => 'abc.csproj', :path => @dir, :content => ProjectFileData.with_dependencies
          FileSystem.write! :name => 'abc.csproj', :path => File.join(@dir, 'def'), :content => ProjectFileData.with_dependencies

          Dir.stub!('[]').and_return(['Libraries/abc-1.2.3.4.dll'])

          @ivy = IvyConfiguration.builder_for @project
        end

        after :each do
          FileUtils.rm_rf @dir
        end

        it "should not modify system references" do
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'abc.csproj')

          doc = REXML::Document.new xml
          doc.get_elements('//Reference[starts_with(@Include, "System")]/HintPath').should be_empty
        end

        it "should not modify SpecificVersion if it exists" do
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'abc.csproj')

          doc = REXML::Document.new xml
          doc.elements['//Reference[starts_with(@Include, "Castle.DynamicProxy")]/SpecificVersion'].text.should == 'True'
        end

        it "should add SpecificVersion as false if it doesn't exist" do
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'abc.csproj')

          doc = REXML::Document.new xml
          doc.elements['//Reference[starts_with(@Include, "ICSharpCode.SharpZipLib")]/SpecificVersion'].text.should == 'false'
        end


        it "should modify Version" do
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'abc.csproj')

          doc = REXML::Document.new xml
          doc.get_elements('//Reference[contains(@Include, "Version=1.2.3.4")]').should_not be_empty
        end

        it "should modify hint path of references to Libraries dir" do
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'abc.csproj')

          doc = REXML::Document.new xml
          doc.each_element('//Reference[not(starts_with(@Include, "System"))]') do |reference|
            hint_path = reference.elements['HintPath']
            hint_path.should_not be_nil
            hint_path.text.should match /^\.\.\\Libraries\\abc.dll/
          end
        end

        it "should modify hint path of references to Libraries dir, considering relative paths" do
          @project.path = File.join(@dir, 'def')
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'def', 'abc.csproj')

          doc = REXML::Document.new xml
          doc.each_element('//Reference[not(starts_with(@Include, "System"))]') do |reference|
            hint_path = reference.elements['HintPath']
            hint_path.should_not be_nil
            hint_path.text.should match /^\.\.\\\.\.\\Libraries\\abc.dll/
          end
        end
      end

    end

  end
end

