require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Anvil do
  before :each do
    TempHelper::cleanup
    @solution_root = SolutionData::all_kinds_of_projects_to_temp_dir
  end

  it 'should provide an accessor for the solution loaded' do
    Anvil.new.should respond_to(:solution)
  end
  
  it 'should provide an accessor for the projects loaded' do
    Anvil.new.should respond_to(:projects)
  end

  describe 'loading from a path' do
    before :each do
      TempHelper::cleanup
      @solution_root = SolutionData::all_kinds_of_projects_to_temp_dir
      @solution_name = 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects'
    end
    
    it 'should have a method to do it' do
      Anvil.should respond_to(:load)
    end

    it 'should scan the directory for *.sln files and return the anvil with a solution loaded' do
      anvil = Anvil.load @solution_root
      anvil.solution.should_not be_nil
      anvil.solution.should be_an_instance_of(Solution)
      anvil.solution.name.should be_eql(@solution_name)
    end
  end
  
  describe 'loading the projects from the solution' do
    before :each do
      TempHelper::cleanup
      @solution_root = SolutionData::all_kinds_of_projects_to_temp_dir
      @solution_name = 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects'
      @anvil = Anvil.load @solution_root
      @project_names = [
        @asp_net = 'MACSkeptic.Iron.Hammer.Asp.Net',
        @asp_net_mvc = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc',
        @tests = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc.Tests',
        @dll = 'MACSkeptic.Iron.Hammer.Dll',
        @wcf = 'MACSkeptic.Iron.Hammer.WCF'
      ]
    end
    
    it 'should have a method to do it' do
      @anvil.should respond_to(:load_projects_from_solution)
    end

    it 'should load all the projects belonging to the solution' do
      @anvil.load_projects_from_solution
      @anvil.projects.should_not be_nil
      @anvil.projects.should be_an_instance_of(Array)
      @anvil.projects.should have(@project_names.length).elements
    end
  end
end
