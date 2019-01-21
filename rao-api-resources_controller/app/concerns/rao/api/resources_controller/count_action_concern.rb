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
        base_scope = resource_class
        scope = add_conditions_from_query(base_scope)
        @count = scope.count
      end
    end
  end
end