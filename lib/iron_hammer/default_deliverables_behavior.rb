module IronHammer
  module DefaultDeliverablesBehavior
    def deliverables params={}
      [binaries(params), configuration(params[:environment] || IronHammer::Defaults::ENVIRONMENT)].flatten
    end
  end unless defined? DefaultDeliverablesBehavior
end
