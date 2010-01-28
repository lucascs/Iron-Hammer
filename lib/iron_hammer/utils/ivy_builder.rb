require 'builder'
module IronHammer
  module Utils
    class IvyBuilder
      
      def initialize project
        @project = project
        @organisation = ORGANISATION || "org"
      end 
   
      def to_s
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.tag! 'ivy-module', :version => '2.0' do
          xml.info :organisation => @organisation, :module => @project.name
          xml.publications do
            xml.artifact :name => @project.name, :type => 'dll'
          end if @project.is_a? DllProject
          
          xml.dependencies do
            @project.dependencies.each do |dependency|
              xml.dependency :org => @organisation, :name => dependency.name, :rev => dependency.version
            end
          end unless @project.dependencies.empty?
        end
      end
      
      def write_to file
        File.open(file, "w") { |f| f.write to_s }
      end
    end
  end
end
