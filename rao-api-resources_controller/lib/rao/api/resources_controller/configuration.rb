module Rao
  module Api
    module ResourcesController
      module Configuration
        def configure
          yield self
        end

        mattr_accessor(:resources_controller_base_class_name) { '::ApplicationController' }
      end
    end
  end
end