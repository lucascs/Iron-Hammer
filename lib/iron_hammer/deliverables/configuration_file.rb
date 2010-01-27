require 'iron_hammer/deliverables/deliverable'

module IronHammer
  module Deliverables
    class ConfigurationFile
      PATTERN = '*.{config,config.xml}'

      def self.list params={}
        path        = params[:path] || raise(ArgumentError.new('must inform a path'))
        environment = params[:environment]
        suffix      = environment ? ('.' + environment) : ''
        pattern     = PATTERN + suffix
        
        Dir[File.join(path, pattern)].collect do |file|
          Deliverable.new(
            :path_on_package => '', 
            :actual_path => path, 
            :actual_name => original_name = file.split('/').last,
            :name_on_package => original_name.sub(suffix, '')
          )
        end
      end
    end unless defined? ConfigurationFile
  end
end
