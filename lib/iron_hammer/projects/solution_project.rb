module IronHammer
  module Projects
    class SolutionProject

      def initialize name, dependencies
        @name = name
        @dependencies = dependencies
      end

      def assembly_name
        @name
      end

      def dependencies
        @dependencies
      end

    end unless defined? SolutionProject
  end
end

