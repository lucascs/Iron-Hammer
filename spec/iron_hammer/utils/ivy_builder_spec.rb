require 'iron_hammer/utils/ivy_builder'
require 'rexml/document'

module IronHammer
  module Utils
    describe IvyBuilder do
      it "should build a xml for a basic project" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:assembly_name).and_return "MyProjectArtifact"
        @ivy = IvyBuilder.new project

        xml = @ivy.to_s
        xml.should match /<info .*\/>/
        xml.should match /organisation="org"/
        xml.should match /module="MyProjectArtifact"/
      end

      it "should add binaries as artifacts" do
        project = DllProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:assembly_name).and_return "MyProjectArtifact"

        @ivy = IvyBuilder.new project

        xml = @ivy.to_s
        xml.should match /<publications>.*<\/publications>/ms
        xml.should match /<artifact .*\/>/
        xml.should match /name="MyProjectArtifact"/
        xml.should match /type="dll"/
      end

      it "should include project dependencies" do
        project = mock(GenericProject)
        project.stub!(:name).and_return "MyProject"
        project.stub!(:dependencies).and_return [Dependency.new(:name => "My Dependency", :version => "1.2.3")]
        project.stub!(:assembly_name).and_return "MyProjectArtifact"

        @ivy = IvyBuilder.new project

        xml = @ivy.to_s
        xml.should match /<dependencies>.*<\/dependencies>/ms
        xml.should match /<dependency .*\/>/
        xml.should match /org="org"/
        xml.should match /name="My Dependency"/
        xml.should match /rev="1.2.3"/
      end

      it "should write the xml to a file" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:assembly_name).and_return "MyProjectArtifact"
        @ivy = IvyBuilder.new project

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
        @ivy = IvyBuilder.new project

        command = @ivy.retrieve "ivy.xml"

        command.should match /-ivy ivy.xml/
        command.should match /-retrieve/
      end

      it "should generate publish command, including binaries path" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        project.stub!(:path_to_binaries).and_return "binaries/here"
        @ivy = IvyBuilder.new project

        command = @ivy.publish "ivy.xml"

        command.should match /-ivy ivy.xml/
        command.should match /-publish/
        command.should match /-publishpattern binaries\/here\/\[artifact\].\[ext\]/
        command.should match /-revision/
      end

      describe "modifying csproj" do
        before :each do
          @dir = 'abc'.inside_temp_dir
          project = GenericProject.new :path => @dir, :csproj => 'abc.csproj', :name => 'abc'

          FileSystem.write! :name => 'abc.csproj', :path => @dir, :content => ProjectFileData.with_dependencies

          lib_dir = mock(Dir)
          lib_dir.stub!(:find).and_return "abc.dll"

          Dir.stub!(:new).with(File.join(@dir, '..', 'Libraries')).and_return(lib_dir)

          @ivy = IvyBuilder.new project
        end

        it "should not modify system references" do
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'abc.csproj')

          doc = REXML::Document.new xml
          doc.get_elements('//Reference[starts_with(@Include, "System")]/HintPath').should be_empty
        end


        it "should modify hint path of references to Libraries dir" do
          @ivy.modify_csproj
          xml = FileSystem.read_file(@dir, 'abc.csproj')

          doc = REXML::Document.new xml
          doc.each_element('//Reference[not(starts_with(@Include, "System"))]') do |reference|
            hint_path = reference.elements['HintPath']
            hint_path.should_not be_nil
            hint_path.text.should match /^..\\Libraries/
          end
        end

      end

    end

  end
end

