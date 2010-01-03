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
    
    it "should provide a list of every single file that will be packaged for delivery" do
        temp = TempHelper::TempFolder
        TempHelper::touch '', 'myProject.dll'
        TempHelper::touch '', 'myProject.pdb'
        TempHelper::touch '', 'myProject.foo'
        TempHelper::touch '', 'maiProject.dll'
        TempHelper::touch '', 'maiProject.pdb'
        TempHelper::touch '', 'maiProject.foo'
        TempHelper::touch '', 'maiProject.exe'
        TempHelper::touch '', 'maiProjecto.exe'
    
        project = Project.new :name => "MyProject"
        
        project.should_receive(:path_to_binaries).with('release').and_return(temp)
        
        files_to_deliver = project.files_to_deliver
        
        files_to_deliver.should_not be_nil
        files_to_deliver.should_not be_empty
        files_to_deliver.should(have temp + '/myProject.dll')
        files_to_deliver.should(have temp + '/maiProject.dll')
        files_to_deliver.should(have temp + '/maiProject.exe')
        files_to_deliver.should(have temp + '/maiProjecto.exe')
        files_to_deliver.should_not(have temp + '/myProject.pdb')
        files_to_deliver.should_not(have temp + '/myProject.foo')
        files_to_deliver.should_not(have temp + '/maiProject.pdb')
        files_to_deliver.should_not(have temp + '/maiProject.foo')
    end
end