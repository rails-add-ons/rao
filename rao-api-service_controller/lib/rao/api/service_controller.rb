require "rao/api/service_controller/configuration"
require "rao/api/service_controller/version"
require "rao/api/service_controller/engine"

module Rao
  module Api
    module ServiceController
      extend Configuration
    end
  end
end

Rao.configure { |c| c.register_configuration(:api_service_controller, Rao::Api::ServiceController) }