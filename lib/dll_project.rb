require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/hammer'
require File.dirname(__FILE__) + '/deliverable'
require File.dirname(__FILE__) + '/configuration'
require File.dirname(__FILE__) + '/default_binaries_behavior'
require File.dirname(__FILE__) + '/default_configuration_behavior'
require File.dirname(__FILE__) + '/default_deliverables_behavior'

class DllProject < Project
  include DefaultBinariesBehavior
  include DefaultConfigurationBehavior
  include DefaultDeliverablesBehavior
  
  def path_to_configuration
    @path
  end
  
  def path_to_binaries params={}
    File.join(@path, 'bin', run_configuration(params))
  end
end unless defined? DllProject
