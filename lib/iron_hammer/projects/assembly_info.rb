
module IronHammer
  module Projects
    class AssemblyInfo

      def initialize filename
        @filename = filename
      end

      def version
        matches = file.match /^\[assembly: AssemblyVersion\("(.*)"\)\]$/
        matches[1] if matches
      end

      private
      def file
        @file ||= File.read(@filename)
      end
    end
  end
end

