require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe ProjectTypeGuids do
  it 'should define the constant for the ASP_NET guid' do
    ProjectTypeGuids::constants.should include('ASP_NET')
    ProjectTypeGuids::const_get('ASP_NET').should_not be_nil
  end
  
  it 'should define the constant for the ASP_NET_MVC guid' do
    ProjectTypeGuids::constants.should include('ASP_NET_MVC')
    ProjectTypeGuids::const_get('ASP_NET_MVC').should_not be_nil
  end
  
  it 'should define the constant for the TEST guid' do
    ProjectTypeGuids::constants.should include('TEST')
    ProjectTypeGuids::const_get('TEST').should_not be_nil
  end
end
