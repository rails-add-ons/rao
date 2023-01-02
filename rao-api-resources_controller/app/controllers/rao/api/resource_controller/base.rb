module Rao
  module Api
    module ResourceController
      class Base < Rao::Api::ResourcesController::Configuration.resources_controller_base_class_name.constantize
        include RestActionsConcern
        include ResourceConcern
        include SerializationConcern
        include ExceptionHandlingConcern
      end
    end
  end
end