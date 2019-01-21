module Rao
  module Api
    module ResourcesController::LastActionConcern
      extend ActiveSupport::Concern

      included do
        if respond_to?(:before_action)
          before_action :load_last, only: [:last]
        else
          before_filter :load_last, only: [:last]
        end
      end

      def last
        respond_to do |format|
          if @resource.nil?
            format.json { render json: nil }
          else
            format.json { render json: [serialize_resource(@resource)] }
          end
        end
      end

      private

      def load_last
        base_scope = resource_class
        scope = add_conditions_from_query(base_scope)
        @resource = scope.last
      end
    end
  end
end