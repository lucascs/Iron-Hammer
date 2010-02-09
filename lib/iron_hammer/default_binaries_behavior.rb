require 'iron_hammer/deliverables/deliverable'

module IronHammer
  module DefaultBinariesBehavior
    BIN_PATTERN = '*.{dll,exe}'

    def binaries params={}
      path = path_to_binaries(params)
      Dir[File.join(path, BIN_PATTERN)].collect do |file|
        IronHammer::Deliverables::Deliverable.new(
          :path_on_package => '',
          :actual_path => path,
          :actual_name => file.split('/').last
        )
      end
    end

    def binary_types
      ['dll', 'exe']
    end
  end unless defined? DefaultBinariesBehavior
end

