module Rao
  module Api
    module ServiceController
      module Configuration
        def configure
          yield self
        end

        mattr_accessor(:service_controller_base_class_name) { '::ApplicationController' }
      end
    end
  end
end