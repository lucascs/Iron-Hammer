require 'iron_hammer/projects/generic_project'
require 'iron_hammer/utils/windows'

module IronHammer
  module Projects
    class AspNetProject < GenericProject
      def path_to_binaries
        [@name, "bin"].patheticalize
      end
    end unless defined? AspNetProject
  end
end
