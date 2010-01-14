require File.dirname(__FILE__) + '/windows_utils'
require File.dirname(__FILE__) + '/deliverable'
require File.dirname(__FILE__) + '/package'

class Project
  attr_accessor :name
  attr_accessor :path
  
  DEFAULT_DELIVERY_DIRECTORY = 'delivery'

  def initialize params={}
    @name = params[:name] || 
      raise(ArgumentError.new 'must provide a project name')
    @path = params[:path]
  end
  
  def path_to_binaries configuration=nil
    ''
  end

  def deliverables params={}
    []
  end
  
  def package params={}
    package_root = params[:root] || params[:target] || params[:package_root] || DEFAULT_DELIVERY_DIRECTORY
    Package.new :root => package_root, :deliverables => deliverables(params)
  end
end unless defined? Project
