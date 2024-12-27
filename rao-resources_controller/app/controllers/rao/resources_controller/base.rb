module Rao
  module ResourcesController
    class Base < Rao::ResourcesController::Configuration.resources_controller_base_class_name.constantize
      include RestActionsConcern
      include ResourcesConcern
      include RestResourcesUrlsConcern
      include ResourceInflectionsConcern
      include ReferrerHistoryConcern
    end
  end
end
