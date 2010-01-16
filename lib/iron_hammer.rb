$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module IronHammer
  VERSION = '0.3.1'
  
  module Defaults
    CONFIGURATION_RUN = 'Release'
    DELIVERY_DIRECTORY = 'delivery'
    TEST_CONFIG = 'LocalTestRun.testrunconfig'
    ENVIRONMENT = 'local'
    SYSTEM_ROOT = 'c:\\Windows'
    PROGRAM_FILES = 'c:\\Program Files'
  end unless defined? IronHammer::Defaults
end
