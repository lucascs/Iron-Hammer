module TheFiler
  def self.copy source, destination
    (destination_path_array = destination.split('/')).pop
    destination_path = File.join *destination_path_array
    FileUtils.mkpath destination_path unless destination_path.empty? || File.exists?(destination_path)
    FileUtils.cp source, destination
  end
end unless defined? TheFiler
