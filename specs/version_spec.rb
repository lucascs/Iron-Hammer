require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Version do
  before :each do
    TempHelper::cleanup
    @version = Version.new(
      :major => 1,
      :minor => 4,
      :revision => 2,
      :build_number => 666,
      :built_by => 'macskeptic',
      :control_hash => '{ASDASD-123123asdasd-aZXCxzasd-aasDADZXC}',
      :timestamp => '2009/12/30 10:30:20'
    )
    @yaml_map = {
      'Version' => { 'Major' => 1, 'Minor' => 4, 'Revision' => 2 },
      'Build' => { 'Number' => 666, 'Hash' => '{ASDASD-123123asdasd-aZXCxzasd-aasDADZXC}' },
      'Timestamp' => '2009/12/30 10:30:20',
      'Built By' => 'macskeptic' 
    }
  end

  it 'should provide a yaml representation' do
    @version.should respond_to(:to_yaml)
    YAML::parse(@version.to_yaml).transform.should be_eql(@yaml_map) 
  end
  
  it 'should create a yaml file, containing the yaml representation' do
    @version.should respond_to('create!')
    @version.create! TempHelper::TEMP_FOLDER, 'my.yaml'
    
    File.exists?('my.yaml'.inside_temp_dir).should be_true
    YAML::parse(File.new('my.yaml'.inside_temp_dir)).transform.should be_eql(@yaml_map) 
  end
end
