require 'rubygems'
require 'spec'

Dir[File.dirname(__FILE__) + '/*.rb'].each { |file| require file.sub('.rb', '') unless file == 'spec_helper.rb' }
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file.sub('.rb', '') }
Dir[File.dirname(__FILE__) + '/../data/*.rb'].each { |file| require file.sub('.rb', '') }


