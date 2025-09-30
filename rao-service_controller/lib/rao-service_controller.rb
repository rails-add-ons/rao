require "rao-component"
require "rao-service"
require "responders"
require "simple_form"

require "rao"
require "rao/service_controller/version"
require "rao/service_controller/configuration"
require "rao/service_controller/engine"

module Rao
  module ServiceController
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:service_controller, Rao::ServiceController) }