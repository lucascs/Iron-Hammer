require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe ProjectTypes do
  it 'should provide a method to get a guid for a type' do
    ProjectTypes::should respond_to(:guid_for)
  end
  
  it 'should provide a method to get a type from a guid' do
    ProjectTypes::should respond_to(:type_of)
  end
end
