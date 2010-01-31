require 'iron_hammer/anvil'

module IronHammer
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
        Anvil.should respond_to(:load_from)
      end

      it 'should scan the directory for *.sln files and return the anvil with a solution loaded' do
        sln = 'solution/dummy/root/MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects.sln'
        Dir.should_receive('[]').with(File.join @solution_root, '*.sln').and_return(entries = [sln])
        IronHammer::Solutions::SolutionFile.should_receive(:parse_file).with(sln).and_return(file = 'FFF')

        anvil = Anvil.load_from @solution_root
        anvil.solution.should_not be_nil
        anvil.solution.should be_an_instance_of(IronHammer::Solutions::Solution)
        anvil.solution.name.should be_eql(@solution_name)
        anvil.solution.file.should be_eql(file) 
      end
    end
    
    describe 'loading the projects from the solution' do
      before :each do #awesomeness
        @anvil = Anvil.new(
          :solution => IronHammer::Solutions::Solution.new(
            :name => @solution_name = 'MACSkeptic.Iron.Hammer.All.Kinds.Of.Projects',
            :path => @solution_root = SolutionData::all_kinds_of_projects_to_temp_dir,
            :file => IronHammer::Solutions::SolutionFile.new(@project_hashes = (@project_names = [
              @asp_net = 'MACSkeptic.Iron.Hammer.Asp.Net',
              @asp_net_mvc = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc',
              @tests = 'MACSkeptic.Iron.Hammer.Asp.Net.Mvc.Tests',
              @dll = 'MACSkeptic.Iron.Hammer.Dll',
              @wcf = 'MACSkeptic.Iron.Hammer.WCF'
            ]).collect { |p| { :name => p, :path => p, :csproj => "#{p}.csproj" } } )
          )
        )
      end
      
      it 'should load all the projects belonging to the solution' do
        mock_projects
        
        @anvil.projects.should_not be_nil
        @anvil.projects.should be_an_instance_of(Array)
        @anvil.projects.should have(@project_names.length).elements
        
        (@anvil.projects.select { |p| p.is_a? IronHammer::Projects::AspNetMvcProject }).
          should have(1).asp_net_mvc_project
        (@anvil.projects.select { |p| p.is_a? IronHammer::Projects::AspNetProject }).
          should have(2).asp_net_projects
        (@anvil.projects.select { |p| p.is_a? IronHammer::Projects::TestProject }).
          should have(1).test_project
        (@anvil.projects.select { |p| p.is_a? IronHammer::Projects::DllProject }).
          should have(1).dll_project
      end
      
      it 'should filter dll projects' do
        mock_projects
        @anvil.dll_projects.should have(1).dll_project
      end
      
      it 'should filter test projects' do
        mock_projects
        
        @anvil.test_projects.should have(1).test_project
      end
      
      def mock_projects
        @project_hashes.each do |p|
          project_file = Object.new
          ProjectFile.should_receive(:load_from).with(*[@solution_root, p[:path], p[:csproj]]).and_return(project_file)          
          project_file.should_receive(:type).
            and_return(case p[:name]
                when @asp_net
                  IronHammer::Projects::AspNetProject
                when @asp_net_mvc
                  IronHammer::Projects::AspNetMvcProject
                when @tests
                  IronHammer::Projects::TestProject
                when @dll
                  IronHammer::Projects::DllProject
                when @wcf
                  IronHammer::Projects::AspNetProject
              end)
        end
      end
    end
  end
end
