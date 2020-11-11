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
      resource_router.send(:url_for, { action: :new, only_path: true })
      # if resource_namespace.present?
      #   resource_router.send(:url_for, [resource_namespace, resource_class, { action: :new, only_path: true }].flatten)
      # else
      #   resource_router.send(:url_for, [resource_class, { action: :new, only_path: true }])
      # end
    end

    def collection_path
      resource_router.send(:url_for, { action: :index, only_path: true })
      # if resource_namespace.present?
      #   resource_router.send(:url_for, [resource_namespace, resource_class, { only_path: true }].flatten)
      # else
      #   resource_router.send(:url_for, [resource_class, { only_path: true }])
      # end
    end

    def resource_path(resource)
      resource_router.send(:url_for, { action: :show, id: resource, only_path: true })
      # if resource_namespace.present?
      #   resource_router.send(:url_for, [resource_namespace, resource, { only_path: true }].flatten)
      # else
      #   resource_router.send(:url_for, [resource, { only_path: true }])
      # end
    end

    def edit_resource_path(resource)
      resource_router.send(:url_for, { action: :edit, id: resource, only_path: true })
      # if resource_namespace.present?
      #   resource_router.send(:url_for, [resource_namespace, resource, { action: :edit, only_path: true }].flatten)
      # else
      #   resource_router.send(:url_for, [resource, { action: :edit, only_path: true }])
      # end
    end

    def resource_router
      self
    end
  end
end
