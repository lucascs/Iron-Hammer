module IronHammer
  module Projects
    class Dependency
      attr_accessor :name
      attr_accessor :version
      attr_accessor :extension
      attr_accessor :specific

      def initialize params = {}
        @name = params[:name] || raise(ArgumentError.new('you must specify a name'))
        @version = params[:version]
        @extension = params[:extension] || 'dll'
        @specific = params[:specific] || false
      end

      def == other
        @name == other.name && @version == other.version && @extension == other.extension
      end

      def to_s
        "[Dependency name=#{@name} version=#{@version} extension=#{@extension}]"
      end

      def self.from_reference reference
        includes = reference.attribute(:Include).value
        name = includes.split(', ')[0]
        match = includes.match /Version=(.+?)(,|$)/
        version = match[1] if match
        raise "Cannot parse version on include: #{includes}" unless version
        extension = get_extension reference
        specific_el = reference.elements['SpecificVersion']
        specific = (specific_el && specific_el.text.downcase == 'true') || false
        Dependency.new :name => name, :version => version, :extension => extension, :specific => specific
      end

      def self.from_project project
        unless project.artifacts.empty?
          Dependency.new :name => project.assembly_name, :version => project.version,
            :extension => project.artifacts.first.split('.').last
        end
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

