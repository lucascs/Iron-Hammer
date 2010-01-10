require 'zip/zipfilesystem'

class Package
  attr_accessor :root
  attr_accessor :deliverables
  
  DEFAULT_DELIVERY_DESTINATION = 'delivery'
  
  def initialize params={}
    @root         = params[:root] || DEFAULT_DELIVERY_DESTINATION
    @deliverables = params[:deliverables]
    raise(ArgumentError.new "must provide a list of deliverables") unless 
      @deliverables && !@deliverables.empty?
  end
  
  def pack! file='package.zip'
    organize_deliverables_for_packaging
		Dir.chdir(@root) { zip_current_working_folder_into_this file }
  end
  
  private 
  def zip_current_working_folder_into_this package_name
    Zip::ZipFile::open(package_name, true) do |zip_file|
      Dir[File.join('**', '*')].each do |file|
        zip_file.add(file, file)
      end
    end
  end
	
  def organize_deliverables_for_packaging
    @deliverables.each do |deliverable|
      source = File.join deliverable.actual_path, deliverable.actual_name
      destination_path = File.join @root, deliverable.path_on_package
      destination = File.join destination_path, deliverable.name_on_package
      FileUtils.mkpath destination_path unless File.exists?(destination_path)
      FileUtils.cp source, destination
    end
  end
end unless defined? Package
