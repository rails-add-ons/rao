module Rao
  module ServiceController::RestServiceUrlsConcern
    extend ActiveSupport::Concern

    included do
      helper_method :new_service_path,
                    :create_service_path
    end

    def new_service_path
      resource_router.send(:url_for, { action: :new, only_path: true })
    end

    def create_service_path
      resource_router.send(:url_for, { action: :create, only_path: true })
    end

    def resource_router
      self
    end
  end
end