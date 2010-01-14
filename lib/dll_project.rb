require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/hammer'
require File.dirname(__FILE__) + '/deliverable'

class DllProject < Project
  
  FILES_TO_DELIVER = '*.{dll,exe,config}'
  
  def deliverables params={}
    environment = params[:environment] || Hammer::DEFAULT_ENVIRONMENT
    bin = path_to_binaries(params[:configuration])
    Dir[File.join(bin, FILES_TO_DELIVER)].collect do |file|
      Deliverable.new(
        :path_on_package => '', 
        :actual_path => bin, 
        :actual_name => file.split('/').last
      )
    end
  end
  
  def path_to_binaries configuration=nil
    config = (configuration && !configuration.empty? && configuration) || Hammer::DEFAULT_CONFIGURATION
    File.join(@name, 'bin', config)
  end
  
  def path_to_configuration_files
    ''
  end
  
end unless defined? DllProject
