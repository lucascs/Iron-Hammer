
module IronHammer
  module Configuration

    def self.home
      return ENV['IRON_HAMMER_HOME'] if ENV['IRON_HAMMER_HOME']
      @home = File.join(ENV['USERPROFILE'], '.IronHammer')
      print_message
      generate_config

      @home
    end

    private
    def self.generate_config
      FileUtils.mkpath @home

      sh "setx IRON_HAMMER_HOME \"#{@home}\""

      File.open(File.join(@home, 'rakefile.rb'), 'w') do |f|
        f.write default_rakefile_rb
      end

      File.open(File.join(@home, 'ivysettings.xml'), 'w') do |f|
        f.write default_ivysettings
      end
    end

    def self.print_message
      puts "IRON_HAMMER_HOME environment variable not found! Generating default config on #{@home}"
      puts "You'll need to download apache ivy from http://ant.apache.org/ivy/download.cgi"
      puts "and copy ivy-x.x.x.jar to #{@home}\\ivy.jar"
      puts "You can also edit #{@home}\\rakefile.rb and change any settings you want"
    end

    def self.default_rakefile_rb
      <<EOF
require 'rubygems'

#VISUAL_STUDIO_PATH = ENV['VISUAL_STUDIO_PATH'] || 'C:\\Program Files\\Microsoft Visual Studio 9.0\\Common7\\IDE'
IVY_JAR = "#{ENV['IRON_HAMMER_HOME']}\\ivy.jar"
IVY_SETTINGS = "#{ENV['IRON_HAMMER_HOME']}\\ivysettings.xml"
#ORGANISATION = 'Your company'

require 'iron_hammer/tasks'
EOF
    end

    def self.default_ivysettings
      <<EOF
<ivysettings>
  <settings defaultResolver="default" />
  <caches defaultCacheDir="#{@home}/Ivy/Cache"/>
  <resolvers>
    <filesystem name="default">
      <ivy pattern="#{@home}/Ivy/Repository/[organisation]/[module]/ivys/ivy-[revision].xml"/>
      <artifact pattern="#{@home}/Ivy/Repository/[organisation]/[module]/[type]s/[artifact]-[revision].[ext]"/>
    </filesystem>
  </resolvers>
</ivysettings>
EOF
    end
  end
end

