class Solution
  attr_accessor :name
  attr_accessor :file
  attr_accessor :path

  def initialize params
    @name = params[:name] || raise(ArgumentError.new 'must provide a solution name')
    @file = params[:file]
    @path = params[:path]
  end
  
  def solution
    "#{@name}.sln"
  end
end unless defined? Solution
