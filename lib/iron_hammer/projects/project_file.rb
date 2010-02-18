require 'rexml/document'
require 'iron_hammer/projects/project_types'
require 'iron_hammer/projects/asp_net_project'
require 'iron_hammer/projects/asp_net_mvc_project'
require 'iron_hammer/projects/test_project'
require 'iron_hammer/projects/dll_project'
require 'iron_hammer/projects/dependency'
require 'iron_hammer/utils/file_system'

module IronHammer
  module Projects
    class ProjectFile
      attr_accessor :path

      GUID_EVALUATION_ORDER = [AspNetMvcProject, AspNetProject, TestProject]
      GUID_PATH = '//Project/PropertyGroup/ProjectTypeGuids'
      ASSEMBLY_NAME_PATH = '//Project/PropertyGroup/AssemblyName'
      REFERENCE_PATH = '//Reference[not(starts_with(@Include, "System"))]'

      def self.load_from *path
        ProjectFile.new path
      end

      def type
        @type ||= ((GUID_EVALUATION_ORDER.inject(false) do |result, current|
          result || (guids.include?(ProjectTypes::guid_for(current)) && current)
        end) || DllProject)
      end

      def assembly_name
        @assembly_name ||= doc.elements[ASSEMBLY_NAME_PATH].text
      end

      def dependencies
        references.collect { |reference| Dependency.from_reference reference }
      end

    private
      def references
        doc && doc.get_elements(REFERENCE_PATH)
      end

      def doc
        @doc ||= REXML::Document.new xml
      end

      def xml
        @xml ||= IronHammer::Utils::FileSystem::read_file(*@path)
      end

      def guids
        return @guids if @guids
        return @guids = [] unless (elem = doc && doc.elements[GUID_PATH]) && elem.text
        @guids = elem.text.split(';').collect { |e| e.upcase }
      end

      def initialize *path
        @path = path
      end
    end unless defined? ProjectFile
  end
end

