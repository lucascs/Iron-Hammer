
module IronHammer
  module Deploy
    class WindowsService

      def initialize ole_service
        @service = ole_service
      end

      def start!
        @service.StartService
      end

      def stop!
        @service.StopService
      end

      def state
        @service.State
      end

    end
  end
end

