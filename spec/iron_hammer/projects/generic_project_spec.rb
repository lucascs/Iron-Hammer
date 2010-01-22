require 'iron_hammer/projects/generic_project'

module IronHammer
  module Projects
    describe GenericProject do
      before :each do
        @project = GenericProject.new :name => 'MyProject'
      end
      
      it 'should setup the project with the given argument' do
        @project.name.should be_eql('MyProject')
      end
      
      it 'should not allow the creation of a project without a name' do
        lambda { GenericProject.new }.should raise_error(ArgumentError)
      end

      describe 'creating a package' do
        before :each do 
          @project = GenericProject.new :name => 'MyProject'
        end
        
        it 'should provide a method that sets it up' do
          @project.should respond_to(:package)
        end
        
        it 'should not fail when given no configuration' do
          @project.should_receive(:deliverables).with({}).and_return(deliverables = [0, 1, 2, 3])
          lambda { @project.package }.should_not raise_error
        end
        
        it 'should not fail when given a nil configuration' do
          @project.should_receive(:deliverables).with(:configuration => nil).and_return(deliverables = [0, 1, 2, 3])
          lambda { @project.package(:configuration => nil) }.should_not raise_error
        end
        
        it 'should not fail when given an empty configuration' do
          @project.should_receive(:deliverables).with(:configuration => '').and_return(deliverables = [0, 1, 2, 3])
          lambda { @project.package(:configuration => '') }.should_not raise_error
        end
        
        it 'should work when given a valid configuration' do
          @project.should_receive(:deliverables).with(:configuration => 'configuration').
            and_return(deliverables = [0, 1, 2, 3])
          package = @project.package(:configuration => 'configuration')
          package.root.should be_eql('delivery')
          package.deliverables.should be_eql(deliverables)
        end 
      end
    end
  end
end
