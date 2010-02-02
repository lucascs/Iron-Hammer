require 'iron_hammer/utils/windows'

module IronHammer
  module Utils
    class CodeAnalyzersEnvironment
      attr_accessor :fxcop_path

      def initialize params={}
        @fxcop_path  = params[:fxcop_path] || default_fxcop_path
      end

      def fxcop
        [@fxcop_path, 'fxcopcmd.exe'].patheticalize
      end

      def fxcop_rules
        [@fxcop_path, 'Rules'].patheticalize
      end

      def fxcop_result
        "fxcop-result.xml"
      end

      private
      def default_fxcop_path
        [
          ENV['ProgramFiles'] || IronHammer::Defaults::PROGRAM_FILES,
          'Microsoft FxCop 1.35'
        ].patheticalize
      end
    end unless defined? CodeAnalyzersEnvironment
  end
end

