module Rao
  module Api
    module ResourceController::ResourceConcern
      extend ActiveSupport::Concern

      def resource_class
        self.class.resource_class
      end
    end
  end
end