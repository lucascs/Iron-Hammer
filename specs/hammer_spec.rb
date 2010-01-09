require File.dirname(__FILE__) + '/../helpers/spec_helper.rb'

describe Hammer do
  before :each do
    @fully_set_hammer = Hammer.new @params_for_fully_set_hammer = {
        :project            => @project            = 'MyProject',
        :solution           => @solution           = 'MySolution',
        :configuration      => @configuration      = 'Debug',
        :dot_net_path       => @dot_net_path       = 'path/to/.net',
        :test_project       => @test_project       = 'TestProject',
        :test_config        => @test_config        = 'TestConfig.testrunconfig',
        :test_dll           => @test_dll           = 'MyTests',
        :visual_studio_path => @visual_studio_path = 'path/to/vs2008' }
    @basic_hammer = Hammer.new :project => @project
  end

  it 'should require either a project or solution name' do
    lambda{ Hammer.new }.should(raise_error ArgumentError)
  end

  it 'should consider solution and project name to be the same when only one of them is informed' do
    Hammer.new(:project => 'MyProject').project.name.should be_eql('MyProject')
    Hammer.new(:project => 'MyProject').solution.name.should be_eql('MyProject')
    Hammer.new(:solution => 'MySolution').solution.name.should be_eql('MySolution')
    Hammer.new(:solution => 'MySolution').project.name.should be_eql('MySolution')
  end
  
  it 'should consider solution and project name to be different when both are informed' do
    hammer = Hammer.new :project => 'MyProject', :solution => 'MySolution'
    hammer.project.name.should be_eql('MyProject')
    hammer.solution.name.should be_eql('MySolution')
  end
  
  it 'should assume the default configuration when it is not informed' do
    @basic_hammer.configuration.should be_eql('Release')
  end
  
  it 'should assume the provided configuration when it is informed' do
    Hammer.new(:project => 'MyProject', :configuration => 'conf').
      configuration.should be_eql('conf')
  end
  
  it 'should provide a proper build command line' do
    msbuild = [@dot_net_path, 'msbuild.exe'].patheticalize

    @fully_set_hammer.
      build.should be_eql("#{msbuild} /p:Configuration=#{@configuration} #{@solution}.sln /t:Rebuild")
  end
  
  it 'should provide a proper command line to run tests' do
    details = ['duration', 'errorstacktrace', 'errormessage', 'outcometext'].inject('') do |buffer, detail|
      buffer << "/detail:#{detail} "
    end
    
    test_dll      = [@test_project, 'bin', @configuration, @test_dll].patheticalize
    results_file  = ['TestResults', 'TestResults.trx'].patheticalize
    mstest        = [@visual_studio_path, 'mstest.exe'].patheticalize
    
    @fully_set_hammer.
      test.should be_eql("#{mstest} /testcontainer:#{test_dll}.dll /resultsfile:#{results_file} #{details}")
  end
end
