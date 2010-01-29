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
      attr_accessor :type

      GUID_EVALUATION_ORDER = [AspNetMvcProject, AspNetProject, TestProject]
      GUID_PATH = '//Project/PropertyGroup/ProjectTypeGuids'
      REFERENCE_PATH = '//Reference[not(starts_with(@Include, "System"))]'

      def initialize params={}
        @type = params[:type] || DllProject
        raise ArgumentError.new('type must be a Class') unless @type.class == Class
      end

      def self.type_of *path
        self.parse(IronHammer::Utils::FileSystem::read_file(*path)).type
      end

      def self.parse xml
        guids = guids_from xml
        ProjectFile.new :type => ((GUID_EVALUATION_ORDER.inject(false) do |result, current|
          result || (guids.include?(ProjectTypes::guid_for(current)) && current)
        end) || DllProject)
      end

      def self.guids_from xml
        doc = REXML::Document.new xml
        elem = doc && doc.elements[GUID_PATH]
        guids = ((elem && elem.text) || '').split(';').collect { |e| e.upcase }
      end

      def self.dependencies_of xml
        doc = REXML::Document.new xml
        references = doc && doc.get_elements(REFERENCE_PATH)
        references.map do |reference|
          Dependency.from_reference reference
        end

      end
    end unless defined? ProjectFile
  end
end

