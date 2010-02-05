
module IronHammer
  module Deploy
    class CreateStatus

      @@status = []
      @@status[0] = "The request was accepted."
      @@status[1] = "The request is not supported."
      @@status[2] = "The user did not have the necessary access."
      @@status[3] = "The service cannot be stopped because other services that are running are dependent on it."
      @@status[4] = "The requested control code is not valid, or it is unacceptable to the service."
      @@status[5] = "The requested control code cannot be sent to the service because the state of the service."
      @@status[6] = "The service has not been started."
      @@status[7] = "The service did not respond to the stop request in a timely fashion."
      @@status[8] = "Unknown failure when stopping the service."
      @@status[9] = "The directory path to the service executable was not found."
      @@status[10] = "The service is already stopped"
      @@status[11] = "The service database is locked."
      @@status[12] = "A dependency which this service relies on has been removed from the system."
      @@status[13] = "The service failed to find the service needed from a dependent service."
      @@status[14] = "The service has been disabled from the system."
      @@status[15] = "The service does not have the correct authentication to run on the system."
      @@status[16] = "This service is being removed from the system."
      @@status[17] = "There is no execution thread for the service."
      @@status[18] = "There are circular dependencies when stopping the service."
      @@status[19] = "There is a service running under the same name."
      @@status[20] = "There are invalid characters in the name of the service."
      @@status[21] = "Invalid parameters have been passed to the service."
      @@status[22] = "The account, which this service is to run under is either invalid or lacks the permissions to run the service."
      @@status[23] = "The service exists in the database of services available from the system."
      @@status[24] = "The service is currently paused in the system."

      def self.text code
        @@status[code]
      end
    end
  end
end

