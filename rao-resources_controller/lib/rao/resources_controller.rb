require "rao/resources_controller/configuration"
require "rao/resources_controller/version"
require "rao/resources_controller/engine"

require "rao/resources_controller/routing/acts_as_list_concern"
require "rao/resources_controller/routing/acts_as_published_concern"

module Rao
  module ResourcesController
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:resources_controller, Rao::ResourcesController) }