require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/deliverable'

class Project
  attr_accessor :name
  FILES_TO_DELIVER = '*.{dll,exe,config}'
  
  def initialize params
    @name = params[:name] || 
      raise(ArgumentError.new "must provide a project name")
  end
  
  def path_to_binaries configuration
    raise(ArgumentError.new "must provide a valid configuration") if 
      configuration.nil? || configuration.empty?
    [@name, "bin", configuration].patheticalize
  end

  def files_to_deliver configuration
    bin = path_to_binaries(configuration)
    Dir[File.join(bin, FILES_TO_DELIVER)].collect do |file|
      Deliverable.new :path_on_package => '', :actual_path => bin, :actual_name => file.split('/').last
    end
  end
  
  def path_to_delivery_directory
    'delivery'
  end
end unless defined? Project
