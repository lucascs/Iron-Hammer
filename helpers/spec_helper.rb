Dir[File.dirname(__FILE__) + '/*.rb'].each { |file| require file.sub('.rb', '') unless file == 'spec_helper.rb' }
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file.sub('.rb', '') }

require 'spec'