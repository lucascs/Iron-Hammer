require 'iron_hammer/utils/ivy_builder'
module IronHammer
  module Utils
    describe IvyBuilder do
      ORGANISATION = "My org"
      it "should build a xml for a basic project" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        @ivy = IvyBuilder.new project
        
        xml = @ivy.to_s
        xml.should match /<info .*\/>/
        xml.should match /organisation="My org"/
        xml.should match /module="MyProject"/
      end
      
      it "should add binaries as artifacts" do
        project = DllProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
                
        @ivy = IvyBuilder.new project
        
        xml = @ivy.to_s
        xml.should match /<publications>.*<\/publications>/ms
        xml.should match /<artifact .*\/>/
        xml.should match /name="MyProject"/
        xml.should match /type="dll"/
      end
      
      it "should include project dependencies" do
        project = mock(GenericProject)
        project.stub!(:name).and_return "MyProject"
        project.stub!(:dependencies).and_return [Dependency.new :name => "My Dependency", :version => "1.2.3"]        

        @ivy = IvyBuilder.new project
        
        xml = @ivy.to_s
        xml.should match /<dependencies>.*<\/dependencies>/ms
        xml.should match /<dependency .*\/>/
        xml.should match /org="My org"/
        xml.should match /name="My Dependency"/
        xml.should match /revision="1.2.3"/
      end
      
      it "should write the xml to a file" do
        project = GenericProject.new :name => "MyProject"
        project.stub!(:dependencies).and_return []
        @ivy = IvyBuilder.new project
        
        file = "#{TempHelper::TEMP_FOLDER}/ivy.xml"
        @ivy.write_to file
        xml = File.read(file)
        xml.should match /<info .*\/>/
        xml.should match /organisation="My org"/
        xml.should match /module="MyProject"/
      end
    end
    
  end
end
