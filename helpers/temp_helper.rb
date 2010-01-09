module TempHelper
    TEMP_FOLDER = File.dirname(__FILE__) + '/../temp/'
    
    def self.cleanup
        FileUtils.rm_rf TEMP_FOLDER
        md ''
    end

    def self.md path
        FileUtils.mkpath path.inside_temp_dir
    end
    
    def self.touch path, file
        md path
        FileUtils.touch File.join(path.inside_temp_dir, file)
    end
    
end unless defined? TempHelper

class String
    def inside_temp_dir
      File.join TempHelper::TEMP_FOLDER, self
    end
end
