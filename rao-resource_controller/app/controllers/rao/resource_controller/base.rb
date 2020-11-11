module Rao
  module ResourceController
    class Base < Rao::ResourceController::Configuration.resource_controller_base_class_name.constantize
      include RestActionsConcern
      include ResourceConcern
      include RestResourceUrlsConcern
      include ResourceInflectionsConcern
      include LocationHistoryConcern
      # include ResourceConcern
      # include ResourceInflectionsConcern
      # include RestResourceUrlsConcern
      # include RestActionsConcern
      # include LocationHistoryConcern

      helper Rao::Component::ApplicationHelper
    end
  end
end