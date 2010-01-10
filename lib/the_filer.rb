module TheFiler
  def self.copy_file! source, destination
    raise(ArgumentError.new 'source must be a file') if File.directory?(source)
    TheFiler::create_path! File.dirname(destination)
    FileUtils.cp source, destination
  end
  
  def self.copy_directory! source, destination
    raise(ArgumentError.new 'source must be a directory') unless File.directory?(source)
    FileUtils.cp_r source, destination
  end
  
  def self.copy! source, destination
    File.directory?(source) ? TheFiler::copy_directory!(source, destination) : TheFiler::copy_file!(source, destination)
  end
  
  def self.write! params={}
    TheFiler::create_path! path = params[:path]
    File.open(File.join(path, name = params[:name]), 'w') { |file| file.write(content = params[:content]) }
  end
  
  def self.read_file *path
    File.open(File.join(*path), 'r') { |file| file.read } unless path.nil? || path.empty?
  end
  
  def self.read_lines *path
    File.open(File.join(*path), 'r') { |file| file.readlines } unless path.nil? || path.empty?
  end
  
  def self.create_path! *path
    FileUtils.mkpath(File.join(*path)) unless path.nil? || path.empty? || File.exists?(File.join(*path))
  end
end unless defined? TheFiler
