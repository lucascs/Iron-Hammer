require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/hammer'
require File.dirname(__FILE__) + '/deliverable'
require File.dirname(__FILE__) + '/configuration'

class DllProject < Project
  BINARIES = '*.{dll,exe}'

  def deliverables params={}
    [binaries(params), configuration(params[:environment] || Hammer::DEFAULT_ENVIRONMENT)].flatten
  end
  
  def binaries params={}
    path = path_to_binaries(params)
    Dir[File.join(path, BINARIES)].collect do |file|
      Deliverable.new(
        :path_on_package => '', 
        :actual_path => path, 
        :actual_name => file.split('/').last
      )
    end
  end
  
  def configuration environment
    conf = Configuration::list :path => path_to_configuration, :environment => environment
    secondary_configuration = Configuration::list :path => path_to_configuration
    secondary_configuration.each {|c| conf << c unless conf.find {|prior| prior.name_on_package == c.name_on_package }}
    conf
  end
  
  def path_to_configuration
    @path
  end
  
  def path_to_binaries params={}
    File.join(@path, 'bin', run_configuration(params))
  end
end unless defined? DllProject
