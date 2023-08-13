module Rao
  module Api
    module ResourcesController
      module ValidationConcern
        extend ActiveSupport::Concern
      
        included do
          before_action :initialize_resource_for_validation, only: [:validate]
        end

        def validate
          respond_to do |format|
            if @resource.valid?
              format.json { render json: { errors: serialize_errors(@resource.errors, full_messages: false) }, status: 200 }
              # format.json { render json: serialize_resource(@resource), status: :created }
            else
              format.json { render json: { errors: serialize_errors(@resource.errors, full_messages: false) }, status: 422 }
            end
          end
        end

        private

        def initialize_resource_for_validation
          initialize_resource_for_create
        end
      end
    end
  end
end
