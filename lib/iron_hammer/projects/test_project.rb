require 'iron_hammer/utils/windows'
require 'iron_hammer/projects/generic_project'

module IronHammer
  module Projects
    class TestProject < GenericProject
      attr_accessor :config
      attr_accessor :dll
      attr_accessor :name
      attr_accessor :path
        
      def initialize params
        @name   = params[:name]     || "#{ params[:project] || params[:solution] }.Tests"
        @dll    = "#{ params[:dll]  || @name}.dll"
        @config = params[:config]   || IronHammer::Defaults::TEST_CONFIG
        @path   = params[:path]
      end

      def container configuration
        [@name, 'bin', configuration, @dll].patheticalize
      end
      
      def results_file
        ['TestResults', 'TestResults.trx'].patheticalize
      end
    end unless defined? TestProject
  end
end
