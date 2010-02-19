require 'builder'
require 'rexml/document'

module IronHammer
  module Utils
    class IvyBuilder
      VERSION_PATTERN = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/
      VERSION_REPLACE = {
        'latest' => '+',
        'latest.major' => '+',
        'latest.minor' => '\\1.+',
        'latest.revision' => '\\1.\\2.+',
        'latest.build' => '\\1.\\2.\\3.+',
        'specific' => '\\1.\\2.\\3.\\4'
      }
      def initialize params={}
        @project = params[:project] || raise('You must specify a project')
        @config = params[:config] || raise('You must specify a config')
      end

      def to_s
        generate_xml @project.dependencies
      end

      def generate_xml dependencies=[]
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.tag! 'ivy-module', :version => '2.0' do
          name = @project.assembly_name
          xml.info :organisation => @config.organisation, :module => name
          xml.publications do
            @project.artifacts.each do |artifact|
              names = artifact.split '.'
              extension = names.pop
              name = names.join '.'
              xml.artifact :name => name, :type => extension
            end
          end if @project.is_a? DllProject

          xml.dependencies do
            dependencies.each do |dependency|
              rev = dependency.version.gsub VERSION_PATTERN, VERSION_REPLACE[@config.retrieve_version]
              xml.dependency :org => @config.organisation, :name => dependency.name, :rev => rev do
                xml.artifact :type => dependency.extension, :name => dependency.name
              end
            end
          end unless dependencies.empty?
        end
      end

      def retrieve ivy_file
        "java -jar #{@config.ivy_jar}
          -ivy #{ivy_file}
          -settings #{@config.ivy_settings}
          -retrieve Libraries/[revision]/[artifact].[ext]".gsub(/\s+/, ' ')
      end

      def publish ivy_file
        "java -jar #{@config.ivy_jar}
          -ivy #{ivy_file}
          -settings #{@config.ivy_settings}
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
          artifact = artifact_for reference
          artifact.scan(/Libraries\/(.*)\/(.*)/) do |version, extension|
            includes = reference.attribute('Include').value
            includes.gsub!(/Version=(.*?)(,|$)/, "Version=#{version}\\2")
            reference.add_attribute('Include', includes)
          end
          reference.elements['SpecificVersion'] = REXML::Element.new('SpecificVersion').add_text('false')
          reference.elements['HintPath'] = REXML::Element.new('HintPath').
                add_text([relative, "#{artifact.gsub(/\//, '\\')}"].flatten.patheticalize)
        end

        FileSystem.write! :path => @project.path, :name => @project.csproj, :content => doc.to_s
      end

      def relative
        ['..'] * @project.path.split(/\/|\\/).size
      end

      private
      def artifact_for reference
        dependency = Dependency.from_reference reference
        Dir["Libraries/**/#{dependency.name}.{dll,exe}"].last
      end
    end
  end
end

