require File.dirname(__FILE__) + '/windows_utils'

class TestProject
  attr_accessor :config
  attr_accessor :dll
  attr_accessor :name
    
  DEFAULT_TEST_CONFIG = "LocalTestRun.testrunconfig"
    
  def initialize params
    @name   = params[:name]     || "#{ params[:project] || params[:solution] }.Tests"
    @dll    = "#{ params[:dll]  || @name}.dll"
    @config = params[:config]   || DEFAULT_TEST_CONFIG
  end

  def container configuration
    [@name, "bin", configuration, @dll].patheticalize
  end
  
  def results_file
    ["TestResults", "TestResults.trx"].patheticalize
  end
end unless defined? TestProject
