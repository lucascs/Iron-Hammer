module TempHelper
    TempFolder = File.dirname(__FILE__) + '/../temp/'
    
    def self.cleanup
        FileUtils.rm_rf TempFolder
        md ''
    end

    def self.md path
        FileUtils.mkpath path.inside_temp_dir
    end
    
    def self.touch path, file
        md path
        FileUtils.touch file.inside_temp_dir
    end
    
end unless defined? TempHelper

class String
    def inside_temp_dir
      File.join TempHelper::TempFolder, self
    end
end
