begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'iron_hammer'

Dir[File.dirname(__FILE__) + '/../helpers/*.rb'].each { |file| require file.sub('.rb', '') }
Dir[File.dirname(__FILE__) + '/../data/*.rb'].each { |file| require file.sub('.rb', '') }
