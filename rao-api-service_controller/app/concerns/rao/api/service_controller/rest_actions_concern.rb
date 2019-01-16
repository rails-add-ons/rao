module Rao
  module Api
    module ServiceController::RestActionsConcern
      extend ActiveSupport::Concern

      included do
        include ActionController::MimeResponds

        unless respond_to?(:respond_to)
          raise "undefined method `respond_to' for #{self.name}: If you are running Rails > 4 you may need to add the responders gem to your Gemfile."
        end

        respond_to :json

        if respond_to?(:before_action)
          before_action :initialize_service_for_create, only: [:create]
        else
          before_filter :initialize_service_for_create, only: [:create]
        end
      end

      def create
        perform
      end

      private

      def perform
        @result = execute_service
        respond_to do |format|
          if @result.success?
            before_respond_on_success if respond_to?(:before_respond_on_success, true)
            format.json { render json: serialize_result(@result), status: :created }
          else
            format.json { render json: { errors: serialize_errors(@result.errors) }, status: 422 }
          end
        end
      end

      def execute_service
        @service.send(execute_method)
      end

      def execute_method
        :perform
      end

      def hashified_params
        if permitted_params.respond_to?(:to_h)
          permitted_params.to_h
        else
          permitted_params
        end
      end

      # Override this method in your child class to manipulate your service before
      # it performs.
      #
      # Example:
      #     # app/controller/import_services_controller.rb
      #     class ImportServices < ApplicationServicesController
      #       #...
      #       private
      #
      #       def initialize_service_for_create
      #         super
      #         @service.current_user_id = session['current_user_id']
      #       end
      #     end
      #
      def initialize_service_for_create
        @service = service_class.new(hashified_params, service_options)
      end

      def service_options
        default_options
      end

      def default_options
        { autosave: true }
      end

      def permitted_params
        raise "You have to implement permitted_params in #{self.class.name}."
      end
    end
  end
end