module DefaultConfigurationBehavior
  def configuration environment
    conf = Configuration::list :path => path_to_configuration, :environment => environment
    secondary_configuration = Configuration::list :path => path_to_configuration
    secondary_configuration.each {|c| conf << c unless conf.find {|prior| prior.name_on_package == c.name_on_package }}
    conf
  end
end unless defined? DefaultConfigurationBehavior
