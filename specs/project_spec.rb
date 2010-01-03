require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Project do
    
    it "should setup the project with the given argument" do
        Project.new(:name => "MyProject").name.should(be_eql "MyProject")
    end
    
    it "should not allow the creation of a project without a name" do
        lambda { Project.new }.should(raise_error ArgumentError)
    end

    it "should provide a path to the binaries given a configuration" do
        Project.new(:name => "MyProject").path_to_binaries("myConf").should(
            be_eql ["MyProject", "bin", "myConf"].patheticalize)
    end
    
    it "should not provide a path to the binaries given an empty configuration" do
        lambda { Project.new(:name => "MyProject").path_to_binaries("") }.should(
            raise_error ArgumentError)
    end
    
    describe "when listing files for the delivery package" do
        before :all do 
            TempHelper::cleanup
            TempHelper::touch '', 'myProject.dll'
            TempHelper::touch '', 'myProject.pdb'
            TempHelper::touch '', 'myProject.foo'
            TempHelper::touch '', 'maiProject.dll'
            TempHelper::touch '', 'maiProject.pdb'
            TempHelper::touch '', 'maiProject.foo'
            TempHelper::touch '', 'maiProject.exe'
            TempHelper::touch '', 'maiProjecto.exe'
            TempHelper::touch '', 'maiProjecto.config'
            TempHelper::touch '', 'mycon.config'
            
            @temp = TempHelper::TempFolder
            @project = Project.new :name => "MyProject"
            @project.should_receive(:path_to_binaries).with('release').and_return(@temp)
            @files_to_deliver = @project.files_to_deliver('release')
        end 
        
        it "should return a list" do
            @files_to_deliver.should_not be_nil
            @files_to_deliver.should(be_an_instance_of Array)
            @files_to_deliver.should_not be_empty
        end
    
        it "should include all .dll's on the list" do
            @files_to_deliver.should(include File.join(@temp, 'myProject.dll'))
            @files_to_deliver.should(include File.join(@temp, 'maiProject.dll'))
        end
        
        it "should include all .exe's on the list" do
            @files_to_deliver.should(include File.join(@temp, 'maiProject.exe'))
            @files_to_deliver.should(include File.join(@temp, 'maiProjecto.exe'))
        end
        
        it "should include all .config's on the list" do
            @files_to_deliver.should(include File.join(@temp, 'maiProjecto.config'))
            @files_to_deliver.should(include File.join(@temp, 'mycon.config'))
        end
        
        it "should not include anything else on the list" do
            @files_to_deliver.should_not(include File.join(@temp, 'myProject.pdb'))
            @files_to_deliver.should_not(include File.join(@temp, 'myProject.foo'))
            @files_to_deliver.should_not(include File.join(@temp, 'maiProject.pdb'))
            @files_to_deliver.should_not(include File.join(@temp, 'maiProject.foo'))
        end
    end
end