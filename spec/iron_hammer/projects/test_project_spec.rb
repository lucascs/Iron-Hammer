require 'iron_hammer/projects/test_project'

module IronHammer
  module Projects
    describe TestProject do
      before :all do
        @basic_test = TestProject.new :name => 'TestProject', :dll => 'TestProject'
      end

      it 'should consider the test project to assume a default name when its name is not informed' do
        test = TestProject.new :project => 'MyProject'
        test.name.should be_eql('MyProject.Tests')

        test = TestProject.new :solution => 'MySolution'
        test.name.should be_eql('MySolution.Tests')
      end

      it 'should consider the test project to be named as provided' do
        test = TestProject.new :name => 'TestProject'
        test.name.should be_eql('TestProject')
      end

      it 'should point to the default testrun config when it is not provided' do
        @basic_test.config.should be_eql('LocalTestRun.testrunconfig')
      end

      it 'should allow the customization of the test configuration' do
        test = TestProject.new :project => 'MyProject', :config => 'TestConfig.testrunconfig'
        test.config.should be_eql('TestConfig.testrunconfig')
      end

      it 'should use assembly_name when dll is not provided' do
        test = TestProject.new :name => 'TestProject'
        test.should_receive(:assembly_name)
        test.dll
      end

      it 'should allow the customization of the test dll' do
        test = TestProject.new :dll => 'TestDll'
        test.dll.should be_eql('TestDll.dll')
      end

      it 'should be able to get csproj name' do
        test = TestProject.new :name => 'MyTest', :csproj => 'MyTestProject.csproj'

        test.csproj.should == 'MyTestProject.csproj'
      end
    end
  end
end

