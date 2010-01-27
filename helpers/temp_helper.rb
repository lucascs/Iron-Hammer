module TempHelper
  TEMP_FOLDER = '/tmp/iron_hammer/' #File.dirname(__FILE__) + '/../temp/'
  
  def self.cleanup
    FileUtils.rm_rf TEMP_FOLDER
    TempHelper::md ''
  end

  def self.md path
    FileUtils.mkpath path.inside_temp_dir
  end
  
  def self.touch path, file
    TempHelper::md path
    FileUtils.touch File.join(path.inside_temp_dir, file)
    ((path.nil? || path.empty? || path == '.') && file) || File.join(path, file)
  end
  
  def self.copy_directory params={}
    TempHelper::md destination = (params[:to] || '')
    FileUtils.cp_r params[:from], destination.inside_temp_dir
  end
end unless defined? TempHelper

class String
  def inside_temp_dir
    File.join TempHelper::TEMP_FOLDER, self
  end
end
