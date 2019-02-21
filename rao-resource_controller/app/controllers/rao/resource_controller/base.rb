module Rao
  module ResourceController
    class Base < Rao::ResourceController::Configuration.resource_controller_base_class_name.constantize
      include RestActionsConcern
      include ResourceConcern
      include RestResourceUrlsConcern
      include ResourceInflectionsConcern
      include LocationHistoryConcern
    end
  end
end