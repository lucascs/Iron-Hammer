require 'iron_hammer/package'
require 'iron_hammer/projects/assembly_info'

module IronHammer
  module Projects
    class GenericProject
      attr_accessor :name
      attr_accessor :path
      attr_accessor :csproj

      def initialize params={}
        @name = params[:name] ||
          raise(ArgumentError.new 'must provide a project name')
        @path = params[:path] || @name
        @csproj = params[:csproj] || "#{@name}.csproj"
      end

      def path_to_binaries params={}
        ''
      end

      def version
        assembly_info.version || '1.0.0.0'
      end

      def deliverables params={}
        []
      end

      def assembly_name
        @assembly_name ||= file.assembly_name
      end

      def assembly_info
        @assembly_info ||= AssemblyInfo.new File.read(File.join @path, 'Properties', 'AssemblyInfo.cs')
      end

      def dependencies
        @dependencies ||= file.dependencies
      end

      def package params={}
        package_root(params)
        Package.new :root => package_root, :deliverables => deliverables(params)
      end

      protected
      def package_root params={}
        root = params[:root] || params[:target] || params[:package_root] || IronHammer::Defaults::DELIVERY_DIRECTORY
      end

      def run_configuration params={}
        configuration = params[:configuration]
        config = (configuration && !configuration.empty? && configuration) || IronHammer::Defaults::CONFIGURATION_RUN
      end

      def file
        @file ||= ProjectFile.load_from path_to_csproj
      end

      def path_to_csproj
        return File.join @path, @csproj
      end
    end unless defined? GenericProject
  end
end

