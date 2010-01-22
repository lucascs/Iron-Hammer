require 'iron_hammer/hammer'

module IronHammer
  describe Hammer do
    before :each do
      @fully_set_hammer = Hammer.new @params_for_fully_set_hammer = {
          :configuration      => @configuration      = 'Debug',
          :dot_net_path       => @dot_net_path       = 'path/to/.net',
          :visual_studio_path => @visual_studio_path = 'path/to/vs2008' }
      @basic_hammer = Hammer.new
    end
    
    it 'should not require either a project or solution name' do
      lambda{ Hammer.new }.should_not raise_error(ArgumentError)
    end

    it 'should assume the default configuration when it is not informed' do
      @basic_hammer.configuration.should be_eql('Release')
    end
    
    it 'should assume the provided configuration when it is informed' do
      Hammer.new(:configuration => 'conf').configuration.should be_eql('conf')
    end
    
    it 'should provide a proper build command line' do
      msbuild = [@dot_net_path, 'msbuild.exe'].patheticalize

      @fully_set_hammer.build(IronHammer::Solutions::Solution.new(:name => 'MySolution')).
        should be_eql("#{msbuild} /p:Configuration=#{@configuration} MySolution.sln /t:Rebuild")
    end
    
    it 'should provide a proper command line to run tests' do
      details = ['duration', 'errorstacktrace', 'errormessage', 'outcometext'].inject('') do |buffer, detail|
        buffer << "/detail:#{detail} "
      end
      
      test_dll      = ['MyTestProject', 'bin', @configuration, 'MyTestProject'].patheticalize
      results_file  = ['TestResults', 'TestResults.trx'].patheticalize
      mstest        = [@visual_studio_path, 'mstest.exe'].patheticalize
      
      @fully_set_hammer.test(IronHammer::Projects::TestProject.new :name => 'MyTestProject').
        should be_eql("#{mstest} /testcontainer:#{test_dll}.dll /resultsfile:#{results_file} #{details}")
    end
	
	describe 'for multiple test projects' do
    it 'should provide a proper command line to run tests' do
        details = ['duration', 'errorstacktrace', 'errormessage', 'outcometext'].inject('') do |buffer, detail|
          buffer << "/detail:#{detail} "
        end
        
        test_dll          = ['MyTestProject', 'bin', @configuration, 'MyTestProject'].patheticalize
        another_test_dll  = ['MyOtherTestProject', 'bin', @configuration, 'MyOtherTestProject'].patheticalize
        results_file      = ['TestResults', 'TestResults.trx'].patheticalize
        mstest            = [@visual_studio_path, 'mstest.exe'].patheticalize
       
        @fully_set_hammer.test(TestProject.new(:name => 'MyTestProject'), TestProject.new(:name => 'MyOtherTestProject')).
          should be_eql("#{mstest} /testcontainer:#{test_dll}.dll /testcontainer:#{another_test_dll}.dll /resultsfile:#{results_file} #{details}")
      end
    end
  end
end
