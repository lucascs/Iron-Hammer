class Deliverable
  attr_accessor :actual_path
  attr_accessor :actual_name
  attr_accessor :path_on_package
  attr_accessor :name_on_package
  
  def initialize params={}
    @actual_path = params[:actual_path] || raise(ArgumentError.new "must provide an actual_path")
    @actual_name = params[:actual_name] || raise(ArgumentError.new "must provide a actual_name")
    @path_on_package = params[:path_on_package] || @actual_path
    @name_on_package = params[:name_on_package] || @actual_name.split('/').last    
  end
  
  def self.create actual_path, actual_name
    Deliverable.new :actual_path => actual_path, :actual_name => actual_name
  end
  
  def == other
    other.class == Deliverable
    @actual_path == other.actual_path
    @actual_name == other.actual_name
    @path_on_package == other.path_on_package
    @name_on_package == other.name_on_package
  end
end unless defined? Deliverable
