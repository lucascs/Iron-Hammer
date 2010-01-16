require 'iron_hammer/deliverables/configuration_file'

module IronHammer
  module DefaultConfigurationBehavior
    def configuration environment
      conf = IronHammer::Deliverables::ConfigurationFile::list :path => path_to_configuration, :environment => environment
      secondary_configuration = IronHammer::Deliverables::ConfigurationFile::list :path => path_to_configuration
      secondary_configuration.each {|c| conf << c unless conf.find {|prior| prior.name_on_package == c.name_on_package }}
      conf
    end
  end unless defined? DefaultConfigurationBehavior
end
