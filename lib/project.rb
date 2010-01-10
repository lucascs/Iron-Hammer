require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/deliverable'
require File.dirname(__FILE__) + '/package'

class Project
  attr_accessor :name
  attr_accessor :path
  
  FILES_TO_DELIVER = '*.{dll,exe,config}'
  DEFAULT_DELIVERY_DIRECTORY = 'delivery'

  def initialize params={}
    @name = params[:name] || 
      raise(ArgumentError.new 'must provide a project name')
    @path = params[:path]
  end
  
  def path_to_binaries configuration=nil
    config = (configuration && !configuration.empty? && configuration) || Hammer::DEFAULT_CONFIGURATION
    [@name, 'bin', config].patheticalize
  end

  def deliverables configuration=nil
    bin = path_to_binaries(configuration)
    Dir[File.join(bin, FILES_TO_DELIVER)].collect do |file|
      Deliverable.new(
        :path_on_package => '', 
        :actual_path => bin, 
        :actual_name => file.split('/').last
      )
    end
  end
  
  def package params={}
    package_root = params[:root] || params[:target] || params[:package_root] || DEFAULT_DELIVERY_DIRECTORY
    Package.new :root => package_root, :deliverables => deliverables(params[:configuration])
  end
end unless defined? Project
