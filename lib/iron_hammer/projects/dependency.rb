module IronHammer
  module Projects
    class Dependency
      attr_accessor :name
      attr_accessor :version
      attr_accessor :extension

      def initialize params = {}
        @name = params[:name] || raise(ArgumentError.new('you must specify a name'))
        @version = params[:version]
        @extension = params[:extension] || 'dll'
      end

      def == other
        @name == other.name && @version == other.version
      end

      def to_s
        "[Dependency name=#{@name} version=#{@version}]"
      end

      def self.from_reference reference
        includes = reference.attribute(:Include).value
        name = includes.split(', ')[0]
        match = includes.match /Version=(.+?)(,|$)/
        version = match[1] if match
        raise "Cannot parse version on include: #{includes}" unless version
        extension = get_extension reference
        Dependency.new :name => name, :version => version, :extension => extension
      end

      private
      def self.get_extension reference
        hint_path = reference.elements["HintPath"]
        return hint_path.text.split(/\./).last if hint_path

        executable_extension = reference.elements["ExecutableExtension"]
        executable_extension.text.gsub(/\./, '') if executable_extension
      end
    end
  end
end

