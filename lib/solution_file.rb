require File.dirname(__FILE__) + '/the_filer'

class SolutionFile
  NAME_PATH_CSPROJ = /.* = \"(.+)\"\, \"(.+)\\(.+)\", .*/
  STOP_TRIGGER = /^Global/
  
  def self.parse lines
    projects = []
    lines.each do |line|
      break if STOP_TRIGGER =~ line
      line.scan(NAME_PATH_CSPROJ) do |name, path, csproj|
        projects << { :name => name, :path => path, :csproj => csproj }
      end
    end
    projects
  end
end unless defined? SolutionFile
