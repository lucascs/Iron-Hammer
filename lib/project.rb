require File.dirname(__FILE__) + '/windows_utils'

class Project

    attr_accessor :name
    
    FilesToDeliver = '*.{dll,exe,config}'
    
    def initialize params
        @name = params[:name] || 
            raise(ArgumentError.new "must provide a project name")
    end
    
    def path_to_binaries configuration
        raise(ArgumentError.new "must provide a valid configuration") if 
            configuration.nil? || configuration.empty?
        [@name, "bin", configuration].patheticalize
    end

    def files_to_deliver configuration
        Dir[File.join(path_to_binaries(configuration), FilesToDeliver)]
    end
    
    def path_to_delivery_directory
        'delivery'
    end
    
end unless defined? Project