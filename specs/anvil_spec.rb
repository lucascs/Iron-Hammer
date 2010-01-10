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
      TheFiler::should_receive(:read_lines).with("#{@solution_root}/#{@solution_name}.sln").and_return(list = [1, 2])
      SolutionFile.should_receive(:parse).with(list).and_return(file = 'ThisIsAFile')
      
      anvil = Anvil.load @solution_root
      anvil.solution.should_not be_nil
      anvil.solution.should be_an_instance_of(Solution)
      anvil.solution.name.should be_eql(@solution_name)
      anvil.solution.file.should be_eql(file) 
    end
  end
  
  describe 'loading the projects from the solution' do
    before :each do
      TempHelper::cleanup
      @anvil = Anvil.new(
        :solution => Solution.new(
          :name => @solution_name = 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects',
          :path => @solution_root = SolutionData::all_kinds_of_projects_to_temp_dir,
          :file => SolutionFile.new(@project_hashes = (@project_names = [
            @asp_net = 'MACSkeptic.Iron.Hammer.Asp.Net',
            @asp_net_mvc = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc',
            @tests = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc.Tests',
            @dll = 'MACSkeptic.Iron.Hammer.Dll',
            @wcf = 'MACSkeptic.Iron.Hammer.WCF'
          ]).collect { |p| { :name => p, :path => p, :csproj => "#{p}.csproj" } } )
        )
      )
    end
    
    it 'should have a method to do it' do
      @anvil.should respond_to(:load_projects_from_solution)
    end

    it 'should load all the projects belonging to the solution' do
      @anvil.load_projects_from_solution
      @anvil.projects.should_not be_nil
      @anvil.projects.should be_an_instance_of(Array)
      @anvil.projects.should have(@project_names.length).elements
      asp_net_mvc_projects = @anvil.projects.select { |p| p.class == AspNetMvcProject }
      asp_net_projects = @anvil.projects.select { |p| p.class == AspNetProject }
      test_projects = @anvil.projects.select { |p| p.class == TestProject }
      dll_projects = @anvil.projects.select { |p| p.class == DllProject }
      asp_net_mvc_projects.should have(1).elements
      asp_net_projects.should have(2).elements
      test_projects.should have(1).elements
      dll_projects.should have(1).elements
    end
  end
end
