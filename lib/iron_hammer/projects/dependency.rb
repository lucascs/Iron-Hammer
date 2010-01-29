module IronHammer
  module Projects
    class Dependency
      attr_accessor :name
      attr_accessor :version

      def initialize params = {}
        @name = params[:name] || raise(ArgumentError.new('you must specify a name'))
        @version = params[:version]
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
        match = includes.match /Version=(.+?),/
        version = match[1] if match
        Dependency.new :name => name, :version => version
      end
    end
  end
end

