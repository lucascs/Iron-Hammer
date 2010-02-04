require 'win32ole' if RUBY_PLATFORM.downcase.include?("mswin")

class WIN32OLE
end unless defined? WIN32OLE

module IronHammer
  module Deploy
    class WMIService

      def initialize computer
        @service = WIN32OLE.connect("winmgmts:{impersonationLevel=impersonate}!\\\\#{computer}\\root\\cimv2")
      end

    end
  end
end

