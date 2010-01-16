module IronHammer
  module WindowsUtils
    def self.patheticalize *params
      return '' if params.nil? || params.empty?
      params[1..-1].inject(String.new params[0]) { |a, b| a << "\\#{b}" }
    end
  end unless defined? WindowsUtils
end

class Array
  def patheticalize
    IronHammer::WindowsUtils::patheticalize *self
  end
end

class String
  def patheticalize
    IronHammer::WindowsUtils::patheticalize *self.split('/')
  end
end
