require File.dirname(__FILE__) + '/solution'
require File.dirname(__FILE__) + '/solution_file'
require File.dirname(__FILE__) + '/the_filer'
require File.dirname(__FILE__) + '/dll_project'
require File.dirname(__FILE__) + '/asp_net_mvc_project'
require File.dirname(__FILE__) + '/asp_net_project'

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
      name = p[:name]
      xml = TheFiler::read_file @solution.path, path = p[:path], csproj = p[:csproj]
      @projects << project = (case ProjectFile.parse(xml).type
        when :dll: DllProject.new(:name => name, :path => path)
        when :test: TestProject.new(:name => name, :path => path)
        when :asp_net: AspNetProject.new(:name => name, :path => path)
        when :asp_net_mvc: AspNetMvcProject.new(:name => name, :path => path)
      end)
    end
  end

  def self.load *path
    pattern = File.join path, '*.sln'
    entries = Dir[pattern]
    unless entries.nil? || entries.empty?
      Anvil.new(
        :solution => Solution.new(
          :name => entries.first.split('/').pop.sub('.sln', ''),
          :file => SolutionFile.parse(TheFiler::read_lines entries.first)
        )
      ) 
    end
  end
end unless defined? Anvil
