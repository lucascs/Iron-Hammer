require 'iron_hammer/projects/dll_project'

module IronHammer
  module Projects
    class DependencyProject < DllProject

      def initialize params
          super(params)
          @binaries_path = params[:binaries_path]
          @version = params[:version] || '1.0.0.0'
          @extension = params[:extension] || 'dll'
      end

      def dependencies
        []
      end

      def assembly_name
        name
      end

      def binary_types
        [@extension]
      end

      def version
        @version
      end

      def path_to_binaries
        @binaries_path
      end
    end unless defined? DependencyProject
  end
end

