require 'yaml'
require 'iron_hammer/utils/file_system'

module IronHammer
  class Version
    attr_accessor :build_number
    attr_accessor :control_hash
    attr_accessor :timestamp
    attr_accessor :built_by
    attr_accessor :major
    attr_accessor :minor
    attr_accessor :revision
    
    def initialize params={}
      @major        = params[:major]        || '#'
      @minor        = params[:minor]        || '#'
      @revision     = params[:revision]     || '#'
      @build_number = params[:build_number] || '##'
      @control_hash = params[:control_hash] || '**********'
      @built_by     = params[:built_by]     || 'MACSkeptic Iron Hammer'
      @timestamp    = params[:timestamp]    || Time.now.strftime('%Y-%m-%d %H:%M:%S')
    end
    
    def to_yaml
      { 
        'Version' => { 'Major' => @major, 'Minor' => @minor, 'Revision' => @revision },
        'Build' => { 'Number' => @build_number, 'Hash' => @control_hash },
        'Timestamp' => @timestamp,
        'Built By' => @built_by 
      }.to_yaml
    end
    
    def create! path, name='version.yaml'
      IronHammer::Utils::FileSystem::write! :path => path, :name => name, :content => to_yaml
    end
  end unless defined? Version
end
