module Rao
  module ResourcesController
    class Base < Rails::AddOns::Configuration.resources_controller_base_class_name.constantize
      include RestActionsConcern
      include ResourcesConcern
      include RestResourceUrlsConcern
      include ResourceInflectionsConcern
      include LocationHistoryConcern
    end
  end
end