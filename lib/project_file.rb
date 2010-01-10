require 'rexml/document'
require File.dirname(__FILE__) + '/project_types'

class ProjectFile
  attr_accessor :type

  GUID_EVALUATION_ORDER = [:asp_net_mvc, :wcf, :asp_net, :test]
  GUID_PATH = '//Project/PropertyGroup/ProjectTypeGuids'

  def initialize params={}
    @type = params[:type] || :dll
  end

  def self.parse xml
    doc = REXML::Document.new xml
    elem = doc && doc.elements[GUID_PATH]
    guids = ((elem && elem.text) || '').split(';').collect { |e| e.upcase }

    ProjectFile.new :type => ((GUID_EVALUATION_ORDER.inject(false) do |result, current|
      result || (guids.include?(ProjectTypes::guid_for(current)) && current)
    end) || :dll)
  end
end unless defined? ProjectFile
