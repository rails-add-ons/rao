require "rao/resource_controller/configuration"
require "rao/resource_controller/version"
require "rao/resource_controller/engine"

module Rao
  module ResourceController
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:resource_controller, Rao::ResourceController) }