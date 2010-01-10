require File.dirname(__FILE__) + '/solution'

class Anvil
  attr_accessor :solution

  def initialize params={}
    @solution = params[:solution]
    @projects = params[:projects]
  end

  def self.load *path
    pattern = File.join path, '*.sln'
    entries = Dir[pattern]
    Anvil.new(:solution => Solution.new(:name => entries.first.split('/').pop.sub('.sln', ''))) unless 
      entries.nil? || entries.empty?
  end
end unless defined? Anvil
