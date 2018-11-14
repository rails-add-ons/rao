module Rao
  module ServiceController::ServiceConcern
    extend ActiveSupport::Concern

    included do
      helper_method :service_class
    end

    def service_class
      self.class.service_class
    end
  end
end