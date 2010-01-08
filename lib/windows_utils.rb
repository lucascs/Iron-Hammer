module WindowsUtils
    def self.patheticalize *params
        params[1..-1].inject(String.new params[0]) { |a, b| a << "\\#{b}" }
    end
end unless defined? WindowsUtils

class Array
    def patheticalize
        WindowsUtils::patheticalize *self
    end
end
