require File.dirname(__FILE__) + '/project_type_guids'

module ProjectTypes
  TYPES = ProjectTypeGuids::constants.inject({}) { |b, c| b.merge(ProjectTypeGuids::const_get(c) => c.downcase.to_sym) }
  GUIDS = TYPES.inject({}) { |buffer, tuple| buffer.merge(tuple.pop.to_sym => tuple.join.to_s) }
  
  def self.type_of guid
    TYPES[guid.to_s]
  end
  
  def self.guid_for type
    GUIDS[type.to_sym]
  end
end unless defined? ProjectTypes
