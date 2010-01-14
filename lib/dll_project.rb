require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/hammer'
require File.dirname(__FILE__) + '/deliverable'

class DllProject < Project
  
  BINARIES = '*.{dll,exe}'
  CONFIGURATION = '*.{config,xml}'
  
  def deliverables params={}
    deliverables = []
    deliverables << binaries(params)
    deliverables << configuration
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
  
  def configuration params={}
    conf_paths = paths_to_configuration(params)
    conf = []
    paths_to_configuration.each do |path|
      Dir[File.join(path, CONFIGURATION)].collect do |file|
        Deliverable.new(
          :path_on_package => '', 
          :actual_path => bin, 
          :actual_name => file.split('/').last
        )
      end
    end
  end
  
  def path_to_binaries params={}
    File.join(@path, 'bin', run_configuration(params))
  end
  
  def paths_to_configuration params={}
    [path_to_binaries(params), @path]
  end
end unless defined? DllProject
