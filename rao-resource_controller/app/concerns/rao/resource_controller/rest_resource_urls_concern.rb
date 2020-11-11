module Rao
  module ResourceController::RestResourceUrlsConcern
    extend ActiveSupport::Concern

    included do
      helper_method :new_resource_path
      helper_method :resource_path
      helper_method :edit_resource_path
    end

    private

    def new_resource_path
      binding.pry
      if resource_namespace.present?
        resource_router.send(:url_for, [resource_namespace, resource_class ,{ action: :new, only_path: true }].flatten)
      else
        resource_router.send(:url_for, [resource_class ,{ action: :new, only_path: true }])
      end
    end

    def resource_path
      if resource_namespace.present?
        resource_router.send(:url_for, [resource_namespace ,{ action: :show, only_path: true }].flatten)
      else
        resource_router.send(:url_for, { action: :show, only_path: true })
      end
    end

    def edit_resource_path
      if resource_namespace.present?
        resource_router.send(:url_for, [resource_namespace, @resource ,{ action: :edit, only_path: true }].flatten)
      else
        resource_router.send(:url_for, [@resource ,{ action: :edit, only_path: true }])
      end
    end

    def resource_router
      self
    end
  end
end
