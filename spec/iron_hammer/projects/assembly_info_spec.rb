require 'iron_hammer/projects/assembly_info'

module IronHammer
  module Projects

    describe AssemblyInfo do
      it "should read version from AssemblyInfo" do
        File.stub!(:read).with("filename").and_return <<ASSEMBLY
... anything
// by using the '*' as shown below:
// [assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
ASSEMBLY

        assembly_info = AssemblyInfo.new "filename"

        assembly_info.version.should == '1.0.0.0'
      end

      describe "modifying version of assembly_info" do
        before :each do
          content = DataHelper::read 'AssemblyInfo.cs'
          path = 'Properties'.inside_temp_dir
          name = 'AssemblyInfo.cs'
          @assembly_info = File.join path, name
          FileSystem.write! :path => path, :name => name, :content => content
        end

        it "should modify actual file when setting version" do
          info = AssemblyInfo.new @assembly_info

          info.version = '1.2.3.4'

          AssemblyInfo.new(@assembly_info).version.should == '1.2.3.4'
        end
      end
    end
  end
end

