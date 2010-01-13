require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Anvil do
  it 'should provide an accessor for the solution loaded' do
    Anvil.new.should respond_to(:solution)
  end
  
  it 'should provide an accessor for the projects loaded' do
    Anvil.new.should respond_to(:projects)
  end

  describe 'loading from a path' do
    before :each do
      @solution_root = 'solution/dummy/root'
      @solution_name = 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects'
    end
    
    it 'should have a method to do it' do
      Anvil.should respond_to(:load_solution_from)
    end

    it 'should scan the directory for *.sln files and return the anvil with a solution loaded' do
      sln = 'solution/dummy/root/MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects.sln'
      Dir.should_receive('[]').with(File.join @solution_root, '*.sln').and_return(entries = [sln])
      SolutionFile.should_receive(:parse_file).with(sln).and_return(file = 'FFF')

      anvil = Anvil.load_solution_from @solution_root
      anvil.solution.should_not be_nil
      anvil.solution.should be_an_instance_of(Solution)
      anvil.solution.name.should be_eql(@solution_name)
      anvil.solution.file.should be_eql(file) 
    end
  end
  
  describe 'loading the projects from the solution' do
    before :all do #awesomeness
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
      @project_hashes.each do |p|
        ProjectFile.should_receive(:type_of).with(@solution_root, p[:path], p[:csproj]).and_return(case p[:name]
          when @asp_net
            AspNetProject
          when @asp_net_mvc
            AspNetMvcProject
          when @tests
            TestProject
          when @dll
            DllProject
          when @wcf
            AspNetProject
        end)
      end
      
      @anvil.load_projects_from_solution

      @anvil.projects.should_not be_nil
      @anvil.projects.should be_an_instance_of(Array)
      @anvil.projects.should have(@project_names.length).elements
      
      (@anvil.projects.select { |p| p.class == AspNetMvcProject }).should have(1).asp_net_mvc_project
      (@anvil.projects.select { |p| p.class == AspNetProject }).should have(2).asp_net_projects
      (@anvil.projects.select { |p| p.class == TestProject }).should have(1).test_project
      (@anvil.projects.select { |p| p.class == DllProject }).should have(1).dll_project
    end
  end
end
