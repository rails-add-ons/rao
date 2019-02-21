module Rao
  module ResourceController::ResourceConcern
    extend ActiveSupport::Concern

    included do
      helper_method :resource_class
    end

    def resource_class
      self.class.resource_class
    end
  end
end