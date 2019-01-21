module Rao
  module Api
    module ResourcesController::ResourcesConcern
      extend ActiveSupport::Concern

      def resource_class
        self.class.resource_class
      end
    end
  end
end