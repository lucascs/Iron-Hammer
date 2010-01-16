require 'iron_hammer/utils/file_system'

module IronHammer
  module Solutions
    class SolutionFile
      attr_accessor :projects

      NAME_PATH_CSPROJ = /.* = \"(.+)\"\, \"(.+)\\(.+)\", .*/
      STOP_TRIGGER = /^Global/

      def initialize projects=[]
        @projects = projects
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
      
      def self.parse_file *path
        self.parse IronHammer::Utils::FileSystem::read_lines(*path) 
      end
    end unless defined? SolutionFile
  end
end
