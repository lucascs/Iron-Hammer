require 'iron_hammer/solutions/solution'
require 'iron_hammer/projects/project_file'
require 'iron_hammer/solutions/solution_file'

module IronHammer
  class Anvil
    attr_accessor :solution
    attr_accessor :projects

    def initialize params={}
      @solution = params[:solution]
      @projects = params[:projects]
    end

    def load_projects_from_solution
      @projects = @projects || []
      @solution.file.projects.each do |p|
        @projects << IronHammer::Projects::ProjectFile.type_of(
          @solution.path, 
          path = p[:path], 
          csproj = p[:csproj]).
        send(:new, p)
      end
    end

    def self.load_solution_from *path
      pattern = File.join path, '*.sln'
      entries = Dir[pattern]
      anvil = Anvil.new(
        :solution => IronHammer::Solutions::Solution.new(
          :name => entries.first.split('/').pop.sub('.sln', ''),
          :file => IronHammer::Solutions::SolutionFile.parse_file(entries.first),
          :path => File.join(*path)
        )
      ) unless entries.nil? || entries.empty?
    end
    
    def dll_projects
      @projects.select {|p| p.is_a? DllProject}
    end
    
    def test_projects
      @projects.select {|p| p.is_a? TestProject}
    end
  end unless defined? Anvil
end
