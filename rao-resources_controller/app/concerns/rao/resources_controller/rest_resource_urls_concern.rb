module Rao
  module ResourcesController::RestResourceUrlsConcern
    extend ActiveSupport::Concern

    included do
      helper_method :new_resource_path
      helper_method :collection_path
      helper_method :resource_path
      helper_method :edit_resource_path
    end

    private

    def new_resource_path
      if respond_to?(:resource_namespace, true)
        resource_router.new_polymorphic_path([resource_namespace, resource_class])
      else
        resource_router.new_polymorphic_path(resource_class)
      end
    end

    def collection_path
      if respond_to?(:resource_namespace, true)
        resource_router.polymorphic_path([resource_namespace, resource_class])
      else
        resource_router.polymorphic_path(resource_class)
      end
    end

    def resource_path(resource)
      if respond_to?(:resource_namespace, true)
        resource_router.polymorphic_path([resource_namespace, resource])
      else
        resource_router.polymorphic_path(resource)
      end
    end

    def edit_resource_path(resource)
      if respond_to?(:resource_namespace, true)
        resource_router.edit_polymorphic_path([resource_namespace, resource])
      else
        resource_router.edit_polymorphic_path(resource)
      end
    end

    def resource_router
      self
    end
  end
end
