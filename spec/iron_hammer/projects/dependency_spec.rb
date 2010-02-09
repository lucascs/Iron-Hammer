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
    end
  end
end

