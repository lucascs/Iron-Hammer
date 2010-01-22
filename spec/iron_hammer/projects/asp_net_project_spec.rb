require 'iron_hammer/projects/asp_net_project'

module IronHammer
  module Projects
    describe AspNetProject do
      it 'should setup the project with the given argument' do
        AspNetProject.new(:name => 'MyWebProject').name.should be_eql('MyWebProject')
      end
      
      it 'should not allow the creation of a project without a name' do
        lambda { AspNetProject.new }.should raise_error(ArgumentError)
      end

      it 'should provide a path to the binaries without the need of a configuration' do
        AspNetProject.new(:name => 'MyWebProject').
          path_to_binaries.should be_eql(['MyWebProject', 'bin'].patheticalize)
      end
    end
  end
end
