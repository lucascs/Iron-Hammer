require 'iron_hammer/package'

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

      def deliverables params={}
        []
      end
      
      def dependencies
        @dependencies ||= ProjectFile.dependencies_of(File.read [@path, @csproj].patheticalize)
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
    end unless defined? GenericProject
  end
end
