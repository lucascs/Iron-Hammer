
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

      def version= new_version
        content = file
        File.open(@filename, 'w') do |f|
          content.each_line do |line|
            line.gsub!(/^(\[assembly: AssemblyVersion\(").*("\)\])$/) do |match|
              "#{$1}#{new_version}#{$2}"
            end
            f << line
          end
        end
      end

      private
      def file
        File.read(@filename)
      end
    end
  end
end

