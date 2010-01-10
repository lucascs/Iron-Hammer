module TheFiler
  def self.copy source, destination
    destination_path = File.dirname destination
    FileUtils.mkpath destination_path unless destination_path.empty? || File.exists?(destination_path)
    FileUtils.cp source, destination
  end
end unless defined? TheFiler
