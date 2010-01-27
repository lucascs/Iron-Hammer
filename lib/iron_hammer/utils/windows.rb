module IronHammer
  module Utils
    class Windows
      def self.patheticalize *params
        return '' if params.nil? || params.empty?
        params[1..-1].inject(String.new params[0]) { |a, b| a << "\\#{b}" }
      end
    end unless defined? Windows
  end
end

class Array
  def patheticalize
    IronHammer::Utils::Windows::patheticalize *self
  end
end unless defined? IRON_HAMMER_UTILS_WINDOWS_ADDED_EXTENSIONS

class String
  def patheticalize
    IronHammer::Utils::Windows::patheticalize *self.split('/')
  end
end unless defined? IRON_HAMMER_UTILS_WINDOWS_ADDED_EXTENSIONS

IRON_HAMMER_UTILS_WINDOWS_ADDED_EXTENSIONS = true
