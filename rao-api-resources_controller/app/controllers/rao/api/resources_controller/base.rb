module Rao
  module Api
    module ResourcesController
      class Base < Rao::Api::ResourcesController::Configuration.resources_controller_base_class_name.constantize
        include RestActionsConcern
        include ResourcesConcern
        include SerializationConcern
        include CountActionConcern
        include DestroyAllActionConcern
        include DeleteAllActionConcern
        include FirstActionConcern
        include LastActionConcern
        include ExceptionHandlingConcern
      end
    end
  end
end