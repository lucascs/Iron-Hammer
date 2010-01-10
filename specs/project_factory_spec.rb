require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe ProjectFactory do  
  describe 'creating a project based on the type and a hash containing name and path' do
    before :each do
      @params = { :name => 'name', :path => 'path' }
    end
    
    it 'should provide a method for doing it' do
      ProjectFactory::should respond_to(:create)
    end
    
    it 'should create correctly a dll project' do 
      project = ProjectFactory::create(@params.merge :type => :dll)
      project.should_not be_nil
      project.should be_an_instance_of(DllProject)
      project.name.should be_eql(@params[:name])
      project.path.should be_eql(@params[:path])
    end
    
    it 'should create correctly a asp_net project' do 
      project = ProjectFactory::create(@params.merge :type => :asp_net)
      project.should_not be_nil
      project.should be_an_instance_of(AspNetProject)
      project.name.should be_eql(@params[:name])
      project.path.should be_eql(@params[:path])
    end
    
    it 'should create correctly a asp_net_mvc project' do 
      project = ProjectFactory::create(@params.merge :type => :asp_net_mvc)
      project.should_not be_nil
      project.should be_an_instance_of(AspNetMvcProject)
      project.name.should be_eql(@params[:name])
      project.path.should be_eql(@params[:path])
    end
    
    it 'should create correctly a test project' do 
      project = ProjectFactory::create(@params.merge :type => :test)
      project.should_not be_nil
      project.should be_an_instance_of(TestProject)
      project.name.should be_eql(@params[:name])
      project.path.should be_eql(@params[:path])
    end
  end
end
