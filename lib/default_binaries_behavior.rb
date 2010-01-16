module DefaultBinariesBehavior
  BINARIES = '*.{dll,exe}'
  
  def binaries params={}
    path = path_to_binaries(params)
    Dir[File.join(path, BINARIES)].collect do |file|
      Deliverable.new(
        :path_on_package => '', 
        :actual_path => path, 
        :actual_name => file.split('/').last
      )
    end
  end
end unless defined? DefaultBinariesBehavior
