module Rao
  module Api
    module ResourcesController::CountActionConcern
      extend ActiveSupport::Concern

      included do
        if respond_to?(:before_action)
          before_action :load_count, only: [:count]
        else
          before_filter :load_count, only: [:count]
        end
      end

      def count
        respond_to do |format|
          format.json { render json: { count: @count } }
        end
      end

      private

      def load_count
        scope = if respond_to?(:with_conditions_from_query, true)
          scope = with_conditions_from_query(resource_class)
        else
          resource_class
        end
        @count = scope.count
      end
    end
  end
end