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
      resource_router.polymorphic_path(resource_class, action: :new)
    end

    def collection_path
      resource_router.polymorphic_path(resource_class)
    end

    def resource_path(resource)
      resource_router.polymorphic_path(resource)
    end

    def edit_resource_path(resource)
      resource_router.polymorphic_path(resource, action: :edit)
    end

    def resource_router
      self
    end
  end
end
