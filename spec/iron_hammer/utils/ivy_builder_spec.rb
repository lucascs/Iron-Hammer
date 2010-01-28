require 'iron_hammer/utils/ivy_builder'
module IronHammer
  module Utils
    describe IvyBuilder do
      it "should build a xml for a basic project" do
        project = GenericProject.new :name => "MyProject"
        
        @ivy = IvyBuilder.new project
        
        xml = @ivy.to_s
        xml.should match /<info .*\/>/
        xml.should match /organisation="MyProject"/
        xml.should match /module="MyProject"/
      end
      
      it "should add binaries as artifacts" do
        project = DllProject.new :name => "MyProject"
        
        @ivy = IvyBuilder.new project
        
        xml = @ivy.to_s
        xml.should match /<publications>.*<\/publications>/ms
        xml.should match /<artifact .*\/>/
        xml.should match /name="MyProject"/
        xml.should match /type="dll"/
      end
      
    end
    
  end
end
