require "haml-rails"
require "responders"
require "rao-component"
require "rao-view_helper"
require "simple_form"

require "rao"
require "rao/resources_controller/version"
require "rao/resources_controller/configuration"
require "rao/resources_controller/engine"

module Rao
  module ResourcesController
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:resources_controller, Rao::ResourcesController) }
