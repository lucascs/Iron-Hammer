class Package
  attr_accessor :root
  
  def initialize path_to_root
    @root = path_to_root  
  end
end unless defined? Package
