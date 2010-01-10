require File.dirname(__FILE__) + '/the_filer'

class SolutionFile
  attr_accessor :projects

  NAME_PATH_CSPROJ = /.* = \"(.+)\"\, \"(.+)\\(.+)\", .*/
  STOP_TRIGGER = /^Global/

  def initialize projects=[]
    @projects = projects;
  end
  
  def self.parse lines
    projects = []
    lines.each do |line|
      break if STOP_TRIGGER =~ line
      line.scan(NAME_PATH_CSPROJ) do |name, path, csproj|
        projects << { :name => name, :path => path, :csproj => csproj }
      end
    end
    SolutionFile.new projects
  end
end unless defined? SolutionFile
