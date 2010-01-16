module DefaultDeliverablesBehavior
  def deliverables params={}
    [binaries(params), configuration(params[:environment] || Hammer::DEFAULT_ENVIRONMENT)].flatten
  end
end unless defined? DefaultDeliverablesBehavior
