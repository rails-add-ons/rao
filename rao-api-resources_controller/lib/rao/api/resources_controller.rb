require "rao/api/resources_controller/configuration"
require "rao/api/resources_controller/version"
require "rao/api/resources_controller/engine"

module Rao
  module Api
    module ResourcesController
      extend Configuration
    end
  end
end

Rao.configure { |c| c.register_configuration(:api_resources_controller, Rao::Api::ResourcesController) }