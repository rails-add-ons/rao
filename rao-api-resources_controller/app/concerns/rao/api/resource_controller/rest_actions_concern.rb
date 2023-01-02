module Rao
  module Api
    module ResourceController::RestActionsConcern
      extend ActiveSupport::Concern

      included do
        include ActionController::MimeResponds

        respond_to :json

        before_action :load_resource_for_show, only: [:show]
        before_action :load_resource, only: [:update, :destroy, :delete]
        before_action :initialize_resource_for_create, only: [:create]
      end

      def show
        respond_to do |format|
          if @resource.nil?
            format.json { render json: { error: "Couldn't find #{resource_class} with ID=#{params[:id]}" }, status: :not_found }
          else
            format.json { render json: serialize_resource(@resource), status: :ok }
          end
        end
      end

      def create
        respond_to do |format|
          if @resource.save
            format.json { render json: serialize_resource(@resource), status: :created }
          else
            format.json { render json: { errors: serialize_errors(@resource.errors) }, status: 422 }
          end
        end
      end

      def update
        respond_to do |format|
          if @resource.update_attributes(permitted_params)
            format.json { render json: serialize_resource(@resource) }
          else
            format.json { render json: { errors: serialize_errors(@resource.errors) }, status: 422 }
          end
        end
      end

      def destroy
        @resource.destroy
        respond_to do |format|
          format.json { render json: serialize_resource(@resource) }
        end
      end

      def delete
        @resource.delete
        respond_to do |format|
          format.json { render json: serialize_resource(@resource) }
        end
      end

      private

      def load_resource
        raise "Please define #load_resource in #{self.class.name} and tell me how to load @resource."
      end

      def load_resource_for_show
        begin
          @resource = load_resource
        rescue ActiveRecord::RecordNotFound
          @resource = nil
        end
      end

      def initialize_resource
        @resource = resource_class.new
      end

      def initialize_resource_for_create
        @resource = resource_class.new(permitted_params)
      end

      def permitted_params
        raise "not implemented"
      end
    end
  end
end
