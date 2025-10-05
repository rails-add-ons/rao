module Rao
  module ServiceController
    # This module provides RESTful actions for a Rails controller, including index, show, new, edit, create, update, and destroy.
    # It is intended to be included in a controller to handle common resource management tasks.
    #
    # Example usage:
    #
    # class PostsController < ApplicationController
    #   include Rao::ResourcesController::Plural::ResourcesConcern
    #   include Rao::ResourcesController::Plural::RestActionsConcern

    #   def self.resource_class
    #     Post
    #   end
    #
    #   private
    #
    #   def resource_params
    #     params.require(:post).permit(:title, :content)
    #   end
    # end
    #
    # The above example assumes you have a `Post` model and you want to manage it using standard RESTful actions.
    # You need to define `resource_class` and `resource_params` methods in your controller.
    #
    # The following actions are provided:
    # - index: Lists all resources.
    # - show: Displays a single resource.
    # - new: Initializes a new resource.
    # - edit: Edits an existing resource.
    # - create: Creates a new resource.
    # - update: Updates an existing resource.
    # - destroy: Deletes an existing resource.
    #
    # The module also provides several hooks that can be overridden in your controller:
    # - load_collection_scope: Customize the scope for loading the collection.
    # - load_collection: Customize the loading of the collection.
    # - load_resource_scope: Customize the scope for loading a single resource.
    # - load_resource: Customize the loading of a single resource.
    # - initialize_resource: Customize the initialization of a new resource.
    # - initialize_resource_for_create: Customize the initialization of a new resource for creation.
    # - resource_params: Define the permitted parameters for the resource.
    #
    module RestActionsConcern
      extend ActiveSupport::Concern

      included do
        include ActionController::MimeResponds
        include ActionView::RecordIdentifier

        respond_to :html, :turbo_stream, :json
        responders :flash

        before_action :initialize_service, only: %i[ new ]
        before_action :initialize_service_for_create, only: %i[ create ]

        helper Rao::Component::ApplicationHelper
      end

      # GET /posts/new
      def new
      end

      # POST /posts or /posts.json
      def create
        @result = @service.perform!

        if @result.ok?
          respond_to do |format|
            format.html { redirect_to after_success_location, notice: success_message }
            format.json { render json: serialize_result, status: :ok }
            format.turbo_stream { redirect_to after_success_location, notice: success_message }
          end
        else
          respond_to do |format|
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: serialize_errors, status: :unprocessable_entity }
            format.turbo_stream { render :new, status: :unprocessable_entity }
          end
        end
      end
    
#      # POST /posts or /posts.json
#      def create
#        @result = @service.perform!
#      
#        if @result.ok?
#          respond_to do |format|
#            if after_success_location.present?
#              format.html { respond_with(@result, location: after_success_location) }
#              format.json { respond_with(@result) }
#              format.turbo_stream { set_flash_message!(@result, :create, :notice) && redirect_to(after_success_location) }
#            else
#              format.html do
#                flash.now[:notice] = success_message
#                render :result
#              end
#              format.json { respond_with(@result) }
#              format.turbo_stream do
#                flash.now[:notice] = t(".success", service_name: @service.class.model_name.human, default: t("flash.actions.perform.success", service_name: @service.class.model_name.human))
#                # set_flash_message!(@result, :performed, :notice)
#                render turbo_stream: [
#                  turbo_stream.replace("flash", partial: "shared/flash", locals: { flash: flash }),
#                  turbo_stream.replace(dom_id(@service, :form), partial: "result_table", locals: { service: @service })
#                ]
#              end
#            end
#          end
#        else
#          respond_to do |format|
#            format.html { respond_with(@result) }
#            format.json { respond_with(@result) }
#            format.turbo_stream do
#              flash.now[:alert] = t(".failure", service_name: @service.class.model_name.human, default: t("flash.actions.perform.failure", service_name: @service.class.model_name.human, errors: @result.errors.full_messages.join(", ")))
#              render turbo_stream: turbo_stream.replace(
#                dom_id(@service, :form),
#                partial: "form_tag",
#                locals: { service: @service }
#              )
#            end
#          end
#        end
#      end
    
      private

      def serialize_result
        @result.to_json
      end

      def serialize_errors
        @result.errors.to_json
      end

      def success_message
        t('flash.actions.perform.success', service_name: @service.class.model_name.human)
      end

      def set_flash_message!(result, action, status = :notice)
        # get a anonymous class and include the Responders::FlashResponder module
        anonymous_class = Class.new(ActionController::Responder) { include Responders::FlashResponder }
        f = anonymous_class.new(self, [result])
        f.send(:set_flash_message!)
      end

      def after_success_location
        new_service_path
      end
      
      # Override this method in your controller to provide a custom back link location.
      def new_back_link_location
        respond_to?(:root_path) ? root_path : nil
      end

      # Override this method in your controller to provide a custom back link location.
      def result_back_link_location
        new_service_path
      end

      # Override this method in your controller to initialize a new service in a custom way.
      def initialize_service
        @service = service_class.new
      end
  
      # Override this method in your controller to initialize a new service for create in a custom way.
      def initialize_service_for_create
        @service = service_class.new(service_params, service_options)
      end
  
      # Only allow a list of trusted parameters through.
      def service_params
        if respond_to?(:permitted_params, true)
          # add permitted_params aliasing service_params adding a deprecation warning
          ActiveSupport::Deprecation.new("1.0.0", "rao-service_controller").warn("The `permitted_params` method is deprecated and will be removed in the next major version. Please use `service_params` instead.", caller_locations)
          return permitted_params
        end

        # params.require(service_class.model_name.singular).permit(*service_class.permitted_params)
        raise "Please implement the `service_params` method in your controller."
      end

      def service_options
        request.format.json? ? { autosave: true } : {}
      end
    end
  end
end
