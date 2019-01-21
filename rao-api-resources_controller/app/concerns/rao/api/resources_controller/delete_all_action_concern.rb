module Rao
  module Api
    module ResourcesController::DeleteAllActionConcern
      extend ActiveSupport::Concern

      included do
        if respond_to?(:before_action)
          before_action :delete_collection, only: [:delete_all]
        else
          before_filter :delete_collection, only: [:delete_all]
        end
      end

      def delete_all
        respond_to do |format|
          format.json { render json: { count: @count } }
        end
      end

      private

      def delete_collection
        @count = resource_class.delete_all
      end
    end
  end
end