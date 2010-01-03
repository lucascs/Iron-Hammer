class Solution

    attr_accessor :name

    def initialize params
        @name = params[:name] || raise(ArgumentError.new "must provide a solution name")
    end
    
    def solution
        "#{@name}.sln"
    end

end unless defined? Solution