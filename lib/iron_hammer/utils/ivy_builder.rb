require 'builder'
require 'rexml/document'

module IronHammer
  module Utils
    class IvyBuilder

      def initialize project
        @project = project
        @organisation = defined?(ORGANISATION)? ORGANISATION : 'org'
        @ivy_jar = defined?(IVY_JAR)? IVY_JAR : 'ivy.jar'
        @ivy_settings = defined?(IVY_SETTINGS)? IVY_SETTINGS : 'ivysettings.xml'
      end

      def to_s
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.tag! 'ivy-module', :version => '2.0' do
          name = @project.assembly_name
          xml.info :organisation => @organisation, :module => name
          xml.publications do
            @project.binary_types.each do |btype|
              xml.artifact :name => name, :type => btype
            end
          end if @project.is_a? DllProject

          xml.dependencies do
            @project.dependencies.each do |dependency|
              rev = dependency.version.gsub /\.\d+$/, '.+'
              xml.dependency :org => @organisation, :name => dependency.name, :rev => rev do
                xml.artifact :type => dependency.extension, :name => dependency.name
              end
            end
          end unless @project.dependencies.empty?
        end
      end

      def retrieve ivy_file
        "java -jar #{@ivy_jar}
          -ivy #{ivy_file}
          -settings #{@ivy_settings}
          -retrieve Libraries/[artifact].[ext]".gsub(/\s+/, ' ')
      end

      def publish ivy_file
        "java -jar #{@ivy_jar}
          -ivy #{ivy_file}
          -settings #{@ivy_settings}
          -publish default
          -publishpattern #{@project.path_to_binaries}/[artifact].[ext]
          -revision #{@project.version}
          -overwrite true".gsub(/\s+/, ' ')
      end

      def write_to file
        File.open(file, "w") { |f| f.write to_s }
      end

      def modify_csproj
        xml = FileSystem.read_file @project.path, @project.csproj
        doc = REXML::Document.new xml
        references = doc.get_elements(ProjectFile::REFERENCE_PATH)
        references.each do |reference|
          reference.elements['SpecificVersion'] = REXML::Element.new('SpecificVersion').add_text('false')
          reference.elements['HintPath'] = REXML::Element.new('HintPath').
                add_text([relative, 'Libraries', "#{artifact_for reference}"].flatten.patheticalize)
        end

        FileSystem.write! :path => @project.path, :name => @project.csproj, :content => doc.to_s
      end

      def relative
        ['..'] * @project.path.split(/\/|\\/).size
      end

      private
      def artifact_for reference
        dependency = Dependency.from_reference reference
        libraries_dir = Dir.new('Libraries')
        libraries_dir.find {|f| f.match "^#{dependency.name}\\.(dll|exe)"}
      end
    end
  end
end

