require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/iron_hammer'

Hoe.plugin :newgem

$hoe = Hoe.spec 'iron_hammer' do
  self.developer 'Mozair Alves do Carmo Junior', 'macskeptic@gmail.com'
  self.post_install_message = 'PostInstall.txt'
  self.rubyforge_name       = self.name
  #self.extra_deps           = [['febeling-rubyzip','>= 0.9.2']]
  self.version              = '0.3.1'
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
