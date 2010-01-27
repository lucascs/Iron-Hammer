module DataHelper
  DATA_FOLDER = File.dirname(__FILE__) + '/../data'

  def self.read *path
    File.open(File.join(DATA_FOLDER, *path), 'r') { |file| file.read }
  end
end unless defined? DataHelper
