require 'iron_hammer/projects/generic_project'
require 'iron_hammer/default_binaries_behavior'
require 'iron_hammer/default_configuration_behavior'
require 'iron_hammer/default_deliverables_behavior'

module IronHammer
  module Projects
    class DllProject < GenericProject
      include IronHammer::DefaultBinariesBehavior
      include IronHammer::DefaultConfigurationBehavior
      include IronHammer::DefaultDeliverablesBehavior
      
      def path_to_configuration
        @path
      end
      
      def path_to_binaries params={}
        File.join(@path, 'bin', run_configuration(params))
      end
    end unless defined? DllProject
  end
end
