require "rao/component/configuration"
require "rao/component/version"
require "rao/component/engine"

module Rao
  module Component
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:component, Rao::Component) }