require 'iron_hammer/utils/zipper'
require 'iron_hammer/utils/file_system'

module IronHammer
  class Package
    attr_accessor :root
    attr_accessor :deliverables
    
    def initialize params={}
      @root         = params[:root] || IronHammer::Defaults::DELIVERY_DIRECTORY
      @deliverables = params[:deliverables]
      raise(ArgumentError.new "must provide a list of deliverables") unless 
        @deliverables && !@deliverables.empty?
    end
    
    def pack! 
      organize_deliverables_for_packaging
      self
    end
    
    def zip! file='package.zip'
      Dir.chdir(@root) { IronHammer::Utils::Zipper::zip_current_working_folder_into_this file }
    end
    
    private 
    def organize_deliverables_for_packaging
      @deliverables.each do |deliverable|
        source = File.join deliverable.actual_path, deliverable.actual_name
        destination = File.join @root, deliverable.path_on_package, deliverable.name_on_package
        IronHammer::Utils::FileSystem::copy! source, destination
      end
    end
  end unless defined? Package
end
