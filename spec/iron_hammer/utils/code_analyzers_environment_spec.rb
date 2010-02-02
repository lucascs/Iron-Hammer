require 'iron_hammer/utils/code_analyzers_environment'

module IronHammer
  module Utils
    describe CodeAnalyzersEnvironment do
      it "should use specified fxcop path if any" do
        @environment = CodeAnalyzersEnvironment.new :fxcop_path => 'abc/def'

        @environment.fxcop_path.should == 'abc/def'
      end

      it "should use a default fxcop path if not specified" do
        @environment = CodeAnalyzersEnvironment.new
        @environment.fxcop_path.should_not be_nil
      end

      it "should be able to get fxcop executable" do
        @environment = CodeAnalyzersEnvironment.new

        @environment.fxcop.should match /fxcopcmd\.exe/
      end
    end
  end
end

