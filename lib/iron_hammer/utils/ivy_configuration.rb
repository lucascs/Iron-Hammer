
module IronHammer
  module Utils
    class IvyConfiguration
      attr_accessor :organisation
      attr_accessor :ivy_jar
      attr_accessor :ivy_settings
      attr_accessor :retrieve_version



      def self.builder_for project
        IvyBuilder.new :config => instance, :project => project
      end


      def self.instance
        @@instance ||= IvyConfiguration.new
      end

      private
      def initialize
        @organisation = defined?(ORGANISATION)? ORGANISATION : 'org'
        @ivy_jar = defined?(IVY_JAR)? IVY_JAR : 'ivy.jar'
        @ivy_settings = defined?(IVY_SETTINGS)? IVY_SETTINGS : 'ivysettings.xml'
        @retrieve_version = ENV['retrieve_version'] || 'latest.build'
      end

    end unless defined? IvyConfiguration
  end
end

