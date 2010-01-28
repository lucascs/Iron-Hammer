require 'iron_hammer/utils/ivy_builder'

module IronHammer
  module Utils
    describe IvyBuilder do
      it "should build a xml for a basic project" do
        project = GenericProject.new :name => "MyProject"
        
        @ivy = IvyBuilder.new project
        
        @ivy.to_s.strip.should == "
<ivy-module version=\"2.0\">
  <info organisation=\"MyProject\" module=\"MyProject\"/>
</ivy-module>
        ".strip
      end
    end
  end
end
