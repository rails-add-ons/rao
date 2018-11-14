module Rao
  module ServiceController
    class Base < Configuration.service_controller_base_class_name.constantize
      include ServiceConcern
      include RestActionsConcern
      include RestServiceUrlsConcern
      include ServiceInflectionsConcern
      include LocationHistoryConcern

      helper Twitter::Bootstrap::Components::Rails::V4::ComponentsHelper
    end
  end
end