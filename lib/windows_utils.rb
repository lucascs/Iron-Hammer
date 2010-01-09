module WindowsUtils
  def self.patheticalize *params
    return '' if params.nil? || params.empty?
    params[1..-1].inject(String.new params[0]) { |a, b| a << "\\#{b}" }
  end
end unless defined? WindowsUtils

class Array
  def patheticalize
    WindowsUtils::patheticalize *self
  end
end
