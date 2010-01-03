Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file.sub('.rb', '') }

require 'spec'