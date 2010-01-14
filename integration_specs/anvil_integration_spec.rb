require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Anvil, ' - full stack integration'  do
  describe 'loading a solution from a path' do
    before :all do
      TempHelper::cleanup
      
      @solution_root = SolutionData::all_kinds_of_projects_to_temp_dir
      @solution_name = 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects'  
      
      @asp_net = 'MACSkeptic.Iron.Hammer.Asp.Net'
      @asp_net_mvc = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc'
      @test = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc.Tests'
      @dll = 'MACSkeptic.Iron.Hammer.Dll'
      @wcf = 'MACSkeptic.Iron.Hammer.WCF'

      @anvil = Anvil::load_solution_from @solution_root
      @solution = @anvil.solution
      @solution_file = @solution.file
      @project_hashes = @solution_file.projects
    end
    
    it 'should have properlu set the solution' do 
      @solution.path.should be_eql(@solution_root)
    end
    
    it 'should properly load the information about the projects in it' do
      @project_hashes.should have(5).projects 
    end  
    
    it 'should properly load the information about the asp_net project' do
      asp_net_projects = @project_hashes.select {|t| t[:name] == @asp_net }
      asp_net_projects.should have(1).projects
      asp_net_project = asp_net_projects.first
      asp_net_project[:name].should be_eql(@asp_net)
      asp_net_project[:path].should be_eql(@asp_net)
      asp_net_project[:csproj].should be_eql(@asp_net + '.csproj')
    end
    
    it 'should properly load the information about the asp_net_mvc project' do  
      asp_net_mvc_projects = @project_hashes.select {|t| t[:name] == @asp_net_mvc }
      asp_net_mvc_projects.should have(1).projects
      asp_net_mvc_project = asp_net_mvc_projects.first
      asp_net_mvc_project[:name].should be_eql(@asp_net_mvc)
      asp_net_mvc_project[:path].should be_eql(@asp_net_mvc)
      asp_net_mvc_project[:csproj].should be_eql(@asp_net_mvc + '.csproj')
    end
    
    it 'should properly load the information about the test project' do  
      test_projects = @project_hashes.select {|t| t[:name] == @test }
      test_projects.should have(1).projects
      test_project = test_projects.first
      test_project[:name].should be_eql(@test)
      test_project[:path].should be_eql(@test)
      test_project[:csproj].should be_eql(@test + '.csproj')
    end
    
    it 'should properly load the information about the wcf project' do  
      wcf_projects = @project_hashes.select {|t| t[:name] == @wcf }
      wcf_projects.should have(1).projects
      wcf_project = wcf_projects.first
      wcf_project[:name].should be_eql(@wcf)
      wcf_project[:path].should be_eql(@wcf)
      wcf_project[:csproj].should be_eql(@wcf + '.csproj')
    end
    
    it 'should properly load the information about the dll project' do  
      dll_projects = @project_hashes.select {|t| t[:name] == @dll }
      dll_projects.should have(1).projects
      dll_project = dll_projects.first
      dll_project[:name].should be_eql(@dll)
      dll_project[:path].should be_eql(@dll)
      dll_project[:csproj].should be_eql(@dll + '.csproj')
    end
    
    describe 'loading the projects from the solution' do
      before :all do
        @anvil.load_projects_from_solution
        @projects = @anvil.projects
      end

      it 'should properly load the projects'do
        @projects.should have(5).projects
      end

      it 'should properly load the asp_net projects' do
        asp_net_projects = @projects.select { |p| p.class == AspNetProject }
        asp_net_projects.should have(2).projects
        
        truly_asp_net_projects = asp_net_projects.select { |p| p.name == @asp_net }
        truly_asp_net_projects.should have(1).project
        truly_asp_net_project = truly_asp_net_projects.first
        truly_asp_net_project.name.should be_eql(@asp_net)
        truly_asp_net_project.path.should be_eql(@asp_net)
        
        wcf_projects = asp_net_projects.select { |p| p.name == @wcf }
        wcf_projects.should have(1).project
        wcf_project = wcf_projects.first
        wcf_project.name.should be_eql(@wcf)
        wcf_project.path.should be_eql(@wcf)
      end
      
      it 'should properly load the asp_net_mvc projects' do
        asp_net_mvc_projects = @projects.select { |p| p.class == AspNetMvcProject }
        asp_net_mvc_projects.should have(1).projects
        asp_net_mvc_project = asp_net_mvc_projects.first
        asp_net_mvc_project.name.should be_eql(@asp_net_mvc)
        asp_net_mvc_project.path.should be_eql(@asp_net_mvc)
      end
      
      it 'should properly load the test projects' do
        test_projects = @projects.select { |p| p.class == TestProject }
        test_projects.should have(1).projects
        test_project = test_projects.first
        test_project.name.should be_eql(@test)
        test_project.path.should be_eql(@test)
      end
      
      it 'should properly load the dll projects' do
        dll_projects = @projects.select { |p| p.class == DllProject }
        dll_projects.should have(1).projects
        dll_project = dll_projects.first
        dll_project.name.should be_eql(@dll)
        dll_project.path.should be_eql(@dll)
      end
    end
  end
end