
module IronHammer
  module Projects
    class AssemblyInfo

      def initialize file
        @file = file
      end

      def version
        matches = @file.match /^\[assembly: AssemblyVersion\("(.*)"\)\]$/
        matches[1] if matches
      end
    end
  end
end

