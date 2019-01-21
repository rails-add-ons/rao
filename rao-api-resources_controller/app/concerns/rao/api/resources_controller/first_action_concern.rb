module Rao
  module Api
    module ResourcesController::FirstActionConcern
      extend ActiveSupport::Concern

      included do
        if respond_to?(:before_action)
          before_action :load_first, only: [:first]
        else
          before_filter :load_first, only: [:first]
        end
      end

      def first
        respond_to do |format|
          if @resource.nil?
            format.json { render json: nil }
          else
            format.json { render json: [serialize_resource(@resource)] }
          end
        end
      end

      private

      def load_first
        base_scope = resource_class
        scope = add_conditions_from_query(base_scope)
        @resource = scope.first
      end
    end
  end
end