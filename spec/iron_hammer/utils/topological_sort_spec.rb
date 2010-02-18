require 'iron_hammer/utils/topological_sort'

class DummyProject
  attr_accessor :name
  attr_accessor :project_references

  def initialize params = {}
    @name = params[:name]
    @project_references = params[:project_references] || []
  end

  def to_s
    @name
  end
end
describe Array do

  describe 'topological sort' do
    it "should be empty if array is empty" do
      [].topological_sort.should be_empty
    end

    it "should include all items" do
      a = DummyProject.new :name => "A", :project_references => []
      b = DummyProject.new :name => "B", :project_references => []
      sort = [a,b].topological_sort
      sort.should include(a)
      sort.should include(b)
    end

    it "should obey references" do
      a = DummyProject.new :name => "A", :project_references => ["B"]
      b = DummyProject.new :name => "B", :project_references => []
      [a,b].topological_sort.should == [b, a]
      [b,a].topological_sort.should == [b, a]
    end

  end
end

