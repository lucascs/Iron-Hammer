require 'rexml/document'

module IronHammer
  module Projects
    describe Dependency do
      before :each do
        @reference = mock(Object)
        @includes = mock(Object)
        @reference.stub!(:attribute).with(:Include).and_return @includes
        elements = mock(Object)
        @reference.stub!(:elements).and_return elements
        elements.stub!('[]').and_return nil
      end

      it "should fill dependency name" do
        @includes.stub!(:value).and_return "MyName, Version=1.2.3.4"

        dependency = Dependency.from_reference @reference
        dependency.name.should == "MyName"
      end

      it "should create a dependency from a project" do
        project = DllProject.new :name => 'project'
        project.stub!(:assembly_name).and_return 'assembly'
        project.stub!(:version).and_return '1.2.3.4'
        project.stub!(:artifacts).and_return ['artifact.exe']

        dependency = Dependency.from_project project
        dependency.should == Dependency.new(:name => 'assembly', :version => '1.2.3.4', :extension => 'exe')
      end

      it "should fill dependency version" do
        @includes.stub!(:value).and_return "MyName, Version=1.2.3.4, anything else"

        dependency = Dependency.from_reference @reference
        dependency.version.should == "1.2.3.4"
      end

      it "should fill dependency version if includes ends with version" do
        @includes.stub!(:value).and_return "MyName, Version=1.2.3.4"

        dependency = Dependency.from_reference @reference
        dependency.version.should == "1.2.3.4"
      end

      it "should fill dependency extension with dll by default" do
        @includes.stub!(:value).and_return "MyName, Version=1.2.3.4, anything else"

        dependency = Dependency.from_reference @reference
        dependency.extension.should == 'dll'
      end

      it "should fill dependency extension using hint path" do
        @reference = REXML::Document.new('<Reference Include="anyName, Version=1.2.3.4"><HintPath>..\\anyFile.exe</HintPath></Reference>').root

        dependency = Dependency.from_reference @reference
        dependency.extension.should == 'exe'
      end

      it "should fill dependency extension using executable extension" do
        @reference = REXML::Document.new('<Reference Include="anyName, Version=1.2.3.4"><ExecutableExtension>.exe</ExecutableExtension></Reference>').root

        dependency = Dependency.from_reference @reference
        dependency.extension.should == 'exe'
      end

      it "should mark dependency as specific if reference have specific version = true" do
        @reference = REXML::Document.new('<Reference Include="anyName, Version=1.2.3.4"><SpecificVersion>true</SpecificVersion></Reference>').root

        dependency = Dependency.from_reference @reference
        dependency.specific.should == true
      end

      it "should mark dependency as specific if reference have specific version = True" do
        @reference = REXML::Document.new('<Reference Include="anyName, Version=1.2.3.4"><SpecificVersion>True</SpecificVersion></Reference>').root

        dependency = Dependency.from_reference @reference
        dependency.specific.should == true
      end

      it "should not mark dependency as specific if reference have specific version = false" do
        @reference = REXML::Document.new('<Reference Include="anyName, Version=1.2.3.4"><SpecificVersion>false</SpecificVersion></Reference>').root

        dependency = Dependency.from_reference @reference
        dependency.specific.should == false
      end
    end
  end
end

