require 'iron_hammer/deploy/windows_service'

module IronHammer
  module Deploy
    describe WindowsService do

      it "should be able to start the service" do
        ole = mock(Object)
        ole.should_receive(:StartService)

        service = WindowsService.new ole

        service.start!
      end

      it "should be able to get the state of the service" do
        ole = mock(Object)
        ole.should_receive(:State)

        service = WindowsService.new ole

        service.state
      end

      it "should be able to stop the service" do
        ole = mock(Object)
        ole.should_receive(:StopService)

        service = WindowsService.new ole

        service.stop!
      end
    end
  end
end

