require File.dirname(__FILE__) + '/dll_project'
require File.dirname(__FILE__) + '/asp_net_mvc_project'
require File.dirname(__FILE__) + '/asp_net_project'
require File.dirname(__FILE__) + '/test_project'

module ProjectFactory
  def self.create params={}
    case params[:type]
      when :dll: DllProject.new(params)
      when :test: TestProject.new(params)
      when :asp_net: AspNetProject.new(params)
      when :asp_net_mvc: AspNetMvcProject.new(params)
    end
  end
end unless defined? ProjectFactory

