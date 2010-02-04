require 'win32ole' if RUBY_PLATFORM.downcase.include?("mswin")

class WIN32OLE
end unless defined? WIN32OLE

module IronHammer
  module Deploy
    class WMIService

      def initialize computer
        @wmi = WIN32OLE.connect("winmgmts:{impersonationLevel=impersonate}!\\\\#{computer}\\root\\cimv2")
      end

      def service name
        services = @wmi.ExecQuery("SELECT * FROM Win32_Service WHERE Name = '#{name}'")
        services.each do |s|
          return WindowsService.new s
        end
      end
    end
  end
end

