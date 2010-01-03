require File.dirname(__FILE__) + '/project'
require File.dirname(__FILE__) + '/windows_utils'

class WebProject < Project
    
    def path_to_binaries
        [@name, "bin"].patheticalize
    end

end