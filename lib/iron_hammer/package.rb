require 'iron_hammer/zipper'
require 'iron_hammer/the_filer'

module IronHammer
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
    
    def pack! 
      organize_deliverables_for_packaging
      self
    end
    
    def zip! file='package.zip'
      Dir.chdir(@root) { Zipper::zip_current_working_folder_into_this file }
    end
    
    private 
    def organize_deliverables_for_packaging
      @deliverables.each do |deliverable|
        source = File.join deliverable.actual_path, deliverable.actual_name
        destination = File.join @root, deliverable.path_on_package, deliverable.name_on_package
        TheFiler::copy! source, destination
      end
    end
  end unless defined? Package
end
