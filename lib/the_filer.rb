module TheFiler
  def self.copy! source, destination
    destination_path = File.dirname destination
    TheFiler::create_path! destination_path
    FileUtils.cp source, destination
  end
  
  def self.write! path, name, content
    TheFiler::create_path! path
    File.open(File.join(path, name), 'w') { |file| file.write(content) }
  end
  
  def self.create_path! path
    FileUtils.mkpath path unless path.nil? || path.empty? || File.exists?(path)
  end
end unless defined? TheFiler
