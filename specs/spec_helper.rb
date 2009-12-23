(Dir[File.dirname(__FILE__) + '/../lib/*.rb'].entries - ['.', '..']).each do |file|
    require file
end

require 'spec'