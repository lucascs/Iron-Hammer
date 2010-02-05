begin
  require 'win32ole'
rescue LoadError
  class WIN32OLE
  end unless defined? WIN32OLE
end

module IronHammer
  module Deploy
    module ServiceType
      KERNEL_DRIVER       = 0x1
      FILE_SYSTEM_DRIVER  = 0x2
      ADAPTER             = 0x4
      RECOGNIZER_DRIVER   = 0x8
      OWN_PROCESS         = 0x10
      SHARE_PROCESS       = 0x20
      INTERACTIVE_PROCESS = 0xFF
    end unless defined? ServiceType

    module ErrorControl
      IGNORE   = 0
      NORMAL   = 1
      SEVERE   = 2
      CRITICAL = 3
    end unless defined? ErrorControl

    module StartMode
      BOOT      = "Boot"
      SYSTEM    = "System"
      AUTOMATIC = "Automatic"
      MANUAL    = "Manual"
      DISABLED  = "Disabled"
    end unless defined? StartMode

    module DesktopInteraction
      INTERACT     = true
      DONT_INTERACT = false
    end unless defined? DesktopInteraction

    class WMIService

      def initialize params ={}
        computer = params[:computer]
        user = params[:user]
        password = params[:password]
        if user && password
          @wmi = WIN32OLE.new("WbemScripting.SWbemLocator").ConnectServer(computer, "root\\cimv2", user, password)
        else
          @wmi = WIN32OLE.connect("winmgmts:{impersonationLevel=impersonate}!\\\\#{computer}\\root\\cimv2")
        end
      end

      def service name
        services = @wmi.ExecQuery("SELECT * FROM Win32_Service WHERE Name = '#{name}'")
        services.each do |s|
          return WindowsService.new s
        end
        nil
      end

      def create! params={}
        base_service.Create(
          params[:name]         || raise(ArgumentError.new "You must specify a name when creating a service"),
          params[:display_name] || params[:name],
          params[:path]         || raise(ArgumentError.new "You must specify a path when creating a service"),
          params[:service_type] || ServiceType::OWN_PROCESS,
          params[:error_control]|| ErrorControl::NORMAL,
          params[:start_mode]   || StartMode::AUTOMATIC,
          params[:desktop_interact] || DesktopInteraction::DONT_INTERACT,
          params[:start_name],
          params[:start_password],
          params[:load_order_group],
          params[:load_order_group_dependencies],
          params[:service_dependencies]
        )
      end

      private
      def base_service
        @base ||= @wmi.Get('Win32_BaseService')
      end
    end
  end
end

