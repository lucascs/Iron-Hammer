require 'iron_hammer/deploy/wmi_service'
require 'iron_hammer/deploy/windows_service'

module IronHammer
  module Deploy
    describe WMIService do

      it "should connect to WMI Service on initialize" do

        WIN32OLE.should_receive(:connect).with("winmgmts:{impersonationLevel=impersonate}!\\\\MyComputer\\root\\cimv2")

        WMIService.new :computer => 'MyComputer'
      end

      describe "locating a windows service" do

        before :each do
          @ole = mock(WIN32OLE)
          WIN32OLE.stub!(:connect).and_return @ole

        end

        it "should find a service" do

          @ole.should_receive(:ExecQuery).with("SELECT * FROM Win32_Service WHERE Name = 'MyService'").and_return []

          wmi = WMIService.new :computer => 'MyComputer'

          wmi.service 'MyService'

        end

        it "should return nil if there are no services with given name" do

          @ole.stub!(:ExecQuery).and_return []

          wmi = WMIService.new :computer => 'MyComputer'

          wmi.service('MyService').should be_nil

        end

        it "should return a WindowsService if any service matches given name" do

          @ole.stub!(:ExecQuery).and_return [@ole]

          wmi = WMIService.new :computer => 'MyComputer'

          wmi.service('MyService').should be_a WindowsService

        end

        describe 'creating a service' do

          it "should open Win32_BaseService and use it to create the new service" do
            base = mock(WIN32OLE)
            @ole.stub!(:Get).with('Win32_BaseService').and_return base
            base.should_receive(:Create)

            wmi = WMIService.new :computer => 'MyComputer'

            wmi.create! :name => 'MyService', :path => '/my/path'
          end

        end
      end
    end
  end
end

