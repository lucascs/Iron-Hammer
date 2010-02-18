$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module IronHammer
  module Defaults
    CONFIGURATION_RUN = 'Release'
    DELIVERY_DIRECTORY = 'delivery'
    TEST_CONFIG = 'LocalTestRun.testrunconfig'
    ENVIRONMENT = 'local'
    SYSTEM_ROOT = 'c:\\Windows'
    PROGRAM_FILES = 'c:\\Program Files'
  end unless defined? IronHammer::Defaults
end

require 'iron_hammer/anvil'
require 'iron_hammer/default_binaries_behavior'
require 'iron_hammer/default_configuration_behavior'
require 'iron_hammer/default_deliverables_behavior'
require 'iron_hammer/deliverables/configuration_file'
require 'iron_hammer/deliverables/deliverable'
require 'iron_hammer/deploy/create_status'
require 'iron_hammer/deploy/windows_service'
require 'iron_hammer/deploy/wmi_service'
require 'iron_hammer/hammer'
require 'iron_hammer/package'
require 'iron_hammer/projects/asp_net_mvc_project'
require 'iron_hammer/projects/asp_net_project'
require 'iron_hammer/projects/assembly_info'
require 'iron_hammer/projects/dependency'
require 'iron_hammer/projects/dependency_project'
require 'iron_hammer/projects/dll_project'
require 'iron_hammer/projects/generic_project'
require 'iron_hammer/projects/project_file'
require 'iron_hammer/projects/project_types'
require 'iron_hammer/projects/solution_project'
require 'iron_hammer/projects/test_project'
require 'iron_hammer/solutions/solution'
require 'iron_hammer/solutions/solution_file'
require 'iron_hammer/utils/code_analyzers_environment'
require 'iron_hammer/utils/dot_net_environment'
require 'iron_hammer/utils/file_system'
require 'iron_hammer/utils/ivy_builder'
require 'iron_hammer/utils/windows'
require 'iron_hammer/utils/zipper'
require 'iron_hammer/version'

include IronHammer
include IronHammer::Projects
include IronHammer::Solutions
include IronHammer::Utils
include IronHammer::Deliverables

