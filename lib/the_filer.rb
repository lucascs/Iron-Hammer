module TheFiler
  def self.copy! source, destination
    TheFiler::create_path! File.dirname(destination)
    FileUtils.cp source, destination
  end
  
  def self.write! path, name, content
    TheFiler::create_path! path
    File.open(File.join(path, name), 'w') { |file| file.write(content) }
  end
  
  def self.read *path
    File.open(File.join(*path), 'r') { |file| file.read } unless path.nil? || path.empty?
  end
  
  def self.read_lines *path
    File.open(File.join(*path), 'r') { |file| file.readlines } unless path.nil? || path.empty?
  end
  
  def self.create_path! *path
    FileUtils.mkpath(File.join(*path)) unless path.nil? || path.empty? || File.exists?(File.join(*path))
  end
end unless defined? TheFiler
