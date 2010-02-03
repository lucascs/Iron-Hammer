require 'iron_hammer/utils/windows'
require 'iron_hammer/projects/generic_project'

module IronHammer
  module Projects
    class TestProject < GenericProject
      attr_accessor :config

      def initialize params = {}
        params[:name] ||= "#{ params[:project] || params[:solution] }.Tests"
        @dll    = "#{params[:dll]}.dll" if params[:dll]
        @config = params[:config]   || IronHammer::Defaults::TEST_CONFIG
        super(params)
      end

      def dll
        @dll ||= "#{assembly_name}.dll"
      end
      def container configuration
        [@path, 'bin', configuration, dll].patheticalize
      end

      def results_file
        ['TestResults', 'TestResults.trx'].patheticalize
      end
    end unless defined? TestProject
  end
end

