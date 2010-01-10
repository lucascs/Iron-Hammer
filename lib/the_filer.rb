module TheFiler
  def self.copy source, destination
    destination_path = File.dirname destination
    TheFiler::mkpath destination_path
    FileUtils.cp source, destination
  end
  
  def self.write path, name, content
    TheFiler::make_path path
    File.open(File.join(path, name), 'w') { |file| file.write(content) }
  end
  
  def self.make_path path
    FileUtils.mkpath path unless path.nil? || path.empty? || File.exists?(path)
  end
end unless defined? TheFiler
