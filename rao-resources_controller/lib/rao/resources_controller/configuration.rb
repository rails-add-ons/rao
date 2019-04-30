module Rao
  module ResourcesController
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:resources_controller_base_class_name) { "::ApplicationController" }
      mattr_accessor(:pagination_per_page_default) { 25 }
    end
  end
end