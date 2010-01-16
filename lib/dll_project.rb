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
  
  def configuration_files_on_the_binaries_directory params={}
    path = path_to_binaries(params)
    environment = params[:environment]
    addendum = environment ? ('.' + environment) : ''
    pattern = CONFIGURATION + addendum
    
    Dir[File.join(path, pattern)].collect do |file|
      Deliverable.new(
        :path_on_package => '', 
        :actual_path => path, 
        :actual_name => original_name = file.split('/').last,
        :name_on_package => original_name.sub(addendum, '')
      )
    end
  end
  
  def configuration_files_on_the_project_root_directory params={}
    environment = params[:environment]
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
  
  def configuration params={}
    conf_paths = paths_to_configuration(params)
    conf = []
    conf_paths.each do |path|
      Dir[File.join(path, prioritary_configuration(params))].each do |file|
        deliverable = Deliverable.new(
          :path_on_package => '', 
          :actual_path => path, 
          :actual_name => file.split('/').last,
          :name_on_package => file.split('/').last.sub('.' + environment(params), '')
        )
        conf << deliverable unless conf.find { |d| d.name_on_package == deliverable.name_on_package }
      end
    
      Dir[File.join(path, CONFIGURATION)].each do |file|
        deliverable = Deliverable.new(
          :path_on_package => '', 
          :actual_path => path, 
          :actual_name => file.split('/').last
        )
        conf << deliverable unless conf.find { |d| d.name_on_package == deliverable.name_on_package }
      end
    end
    conf
  end
  
  def prioritary_configuration params={}
    CONFIGURATION + environment(params)
  end
  
  def path_to_binaries params={}
    File.join(@path, 'bin', run_configuration(params))
  end
  
  def paths_to_configuration params={}
    [@path, path_to_binaries(params)]
  end
end unless defined? DllProject
