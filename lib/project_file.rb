require 'rexml/document'
require File.dirname(__FILE__) + '/project_types'
require File.dirname(__FILE__) + '/the_filer'
require File.dirname(__FILE__) + '/asp_net_project'
require File.dirname(__FILE__) + '/asp_net_mvc_project'
require File.dirname(__FILE__) + '/test_project'
require File.dirname(__FILE__) + '/dll_project'

class ProjectFile
  attr_accessor :type

  GUID_EVALUATION_ORDER = [AspNetMvcProject, AspNetProject, TestProject]
  GUID_PATH = '//Project/PropertyGroup/ProjectTypeGuids'

  def initialize params={}
    @type = params[:type] || DllProject
    raise ArgumentError.new('type must be a Class') unless @type.class == Class
  end
  
  def self.type_of *path
    self.parse(TheFiler::read_file(*path)).type
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
end unless defined? ProjectFile
