require "rao/view_helper/version"
require "rao/view_helper/configuration"
require "rao/view_helper/engine"

module Rao
  module ViewHelper
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:view_helper, Rao::ViewHelper) }