require 'iron_hammer/solutions/solution'
require 'iron_hammer/projects/project_file'
require 'iron_hammer/solutions/solution_file'

module IronHammer
  class Anvil
    attr_accessor :solution

    def self.load_from *path
      target = path
      target = '.' if path.nil? || path.empty?
      pattern = File.join target, '*.sln'
      entries = Dir[pattern]
      anvil = Anvil.new(
        :solution => IronHammer::Solutions::Solution.new(
          :name => entries.first.split('/').pop.sub('.sln', ''),
          :file => IronHammer::Solutions::SolutionFile.parse_file(entries.first),
          :path => File.join(*path)
        )
      ) unless entries.nil? || entries.empty?
    end

    def projects 
      @projects ||= (@solution.file.projects.collect do |p|
        IronHammer::Projects::ProjectFile.type_of(
          @solution.path, 
          path = p[:path], 
          csproj = p[:csproj]).new(p)
      end)
    end
    
    def dll_projects
      @dll_projects ||= projects.select {|p| p.is_a? DllProject}
    end
    
    def test_projects
      @test_projects ||= projects.select {|p| p.is_a? TestProject}
    end
    
    def load_projects_from_solution #deprecated!
      Kernel::warn '[DEPRECATION] `load_projects_from_solution` is deprecated and now it is a no-op. ' +
        'Please, just use `projects` instead - they will be loaded in a lazy fashion ;)'
    end

  private    
    def initialize params={}
      @solution = params[:solution]
      @projects = params[:projects]
    end
  end unless defined? Anvil
end
