require 'builder'
module IronHammer
  module Utils
    class IvyBuilder
      
      def initialize project
        @project = project
      end 
   
      def to_s
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.tag! 'ivy-module', :version => '2.0' do
          xml.info :organisation => @project.name, :module => @project.name
        end
      end   
    end
  end
end
