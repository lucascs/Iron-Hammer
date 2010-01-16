require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/hammer'
require File.dirname(__FILE__) + '/deliverable'

class DllProject < Project
  def configuration_files_on_the_binaries_directory params={}
    path = path_to_binaries(params)
    Dir[File.join(path, CONFIGURATION)].collect do |file|
      Deliverable.new(
        :path_on_package => '', 
        :actual_path => path, 
        :actual_name => file.split('/').last
      )
    end
  end
  BINARIES = '*.{dll,exe}'
  CONFIGURATION = '*.{config,config.xml}'
  
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
  
  def configuration_files_on_the_project_root_directory environment=nil
    addendum = environment ? ('.' + environment) : ''
    pattern = CONFIGURATION + addendum
    Dir[File.join(@path, pattern)].collect do |file|
      Deliverable.new(
        :path_on_package => '', 
        :actual_path => @path, 
        :actual_name => original_name = file.split('/').last,
        :name_on_package => original_name.sub(addendum, '')
      )
    end
  end
  
  def configuration environment=Hammer::DEFAULT_ENVIRONMENT
    conf = configuration_files_on_the_project_root_directory environment
    secondary_configuration = configuration_files_on_the_project_root_directory
    secondary_configuration.each {|c| conf << c unless conf.find {|prior| prior.name_on_package == c.name_on_package }}
    conf
  end
  
  def path_to_binaries params={}
    File.join(@path, 'bin', run_configuration(params))
  end
end unless defined? DllProject
