require File.dirname(__FILE__) + '/solution'
require File.dirname(__FILE__) + '/solution_file'
require File.dirname(__FILE__) + '/the_filer'

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
      @projects << ProjectFile.type_of(@solution.path, path = p[:path], csproj = p[:csproj]).send(:new, p)
    end
  end

  def self.load_solution_from *path
    pattern = File.join *path, '*.sln'
    entries = Dir[pattern]
    anvil = Anvil.new(
      :solution => Solution.new(
        :name => entries.first.split('/').pop.sub('.sln', ''),
        :file => SolutionFile.parse_file(entries.first),
        :path => File.join(*path)
      )
    ) unless entries.nil? || entries.empty?
  end
end unless defined? Anvil
