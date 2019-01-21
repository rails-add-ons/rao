module Rao
  module Api
    module ResourcesController::DestroyAllActionConcern
      extend ActiveSupport::Concern

      included do
        if respond_to?(:before_action)
          before_action :load_and_destroy_collection, only: [:destroy_all]
        else
          before_filter :load_and_destroy_collection, only: [:destroy_all]
        end
      end

      def destroy_all
        respond_to do |format|
          format.json { render json: serialize_collection(@collection) }
        end
      end

      private

      def load_and_destroy_collection
        @collection = resource_class.destroy_all
      end
    end
  end
end