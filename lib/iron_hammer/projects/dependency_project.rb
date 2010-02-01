require 'iron_hammer/projects/dll_project'

module IronHammer
  module Projects
    class DependencyProject < DllProject

      def initialize params
          super(params)
          @binaries_path = params['binaries_path']
      end

      def dependencies
        []
      end

      def assembly_name
        name
      end

      def path_to_binaries
        @binaries_path
      end
    end unless defined? DependencyProject
  end
end

