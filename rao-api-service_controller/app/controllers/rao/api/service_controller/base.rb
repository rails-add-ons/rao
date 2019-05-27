module Rao
  module Api
    module ServiceController
      class Base < Rao::Api::ServiceController::Configuration.service_controller_base_class_name.constantize
        include ServiceConcern
        include RestActionsConcern
        include SerializationConcern
        include ExceptionHandlingConcern
      end
    end
  end
end