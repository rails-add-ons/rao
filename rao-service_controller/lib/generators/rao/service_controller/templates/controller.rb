class <%= controller_class.demodulize %> < ApplicationController
  include Rao::ServiceController::DefaultViewsConcern
  include Rao::ServiceController::InflectionsConcern
  include Rao::ServiceController::RestActionsConcern
  include Rao::ServiceController::RestUrlsConcern
  include Rao::ServiceController::ServiceConcern

  def self.service_class
    <%= service_class %>
  end

  private

  def service_params
    # To require params use:
    #
    # params.require(:<%= params_name %>).permit()
    #
    params.fetch(:<%= params_name %>, {}).permit(<%= permitted_params %>)
  end
end