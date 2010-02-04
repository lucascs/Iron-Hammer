require 'iron_hammer/deploy/wmi_service'

module IronHammer
  module Deploy
    describe WMIService do

      it "should connect to WMI Service on initialize" do

        WIN32OLE.should_receive(:connect).with("winmgmts:{impersonationLevel=impersonate}!\\\\MyComputer\\root\\cimv2")

        WMIService.new 'MyComputer'
      end
    end
  end
end

