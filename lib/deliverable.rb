class Deliverable
  attr_accessor :actual_path
  attr_accessor :actual_name
  attr_accessor :path_on_package
  attr_accessor :name_on_package
  
  def initialize params={}
    @actual_path = params[:actual_path] || raise(ArgumentError.new 'must provide an actual_path')
    @actual_name = params[:actual_name] || raise(ArgumentError.new 'must provide an actual_name')
    @path_on_package = params[:path_on_package] || @actual_path
    @name_on_package = params[:name_on_package] || @actual_name
  end
  
  def self.create actual_path, actual_name, path_on_package=''
    Deliverable.new :actual_path => actual_path, :actual_name => actual_name, :path_on_package => path_on_package
  end
  
  def == other
    other.class == Deliverable &&
      instance_variables.inject(true) { |x, current| x && (send(prop = current.to_s.sub('@','')) == other.send(prop)) }
  end
  
  def eql? other
    self == other
  end
end unless defined? Deliverable
