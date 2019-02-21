module Rao
  module ResourceController
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:resource_controller_base_class_name) { "::ApplicationController" }
    end
  end
end