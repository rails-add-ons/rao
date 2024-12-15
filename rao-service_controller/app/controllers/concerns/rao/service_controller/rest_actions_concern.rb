module Rao
  module ServiceController
    # This module provides RESTful actions for a Rails controller, including index, show, new, edit, create, update, and destroy.
    # It is intended to be included in a controller to handle common resource management tasks.
    #
    # Example usage:
    #
    # class PostsController < ApplicationController
    #   include Rao::ResourcesController::ResourcesConcern
    #   include Rao::ResourcesController::RestActionsConcern

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

        respond_to do |format|
          if @result.ok?
            if respond_to?(:after_success_location, true)
              format.html { redirect_to after_success_location, notice: "#{service_class.model_name.human} was successfully executed." }
            else
              format.html { render :result, status: :created, notice: "#{service_class.model_name.human} was successfully executed." }
            end
            format.json { render json: @result, status: :created }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @result.errors, status: :unprocessable_entity }
          end
        end
      end
    
      private
      
      # Override this method in your controller to provide a custom back link location.
      def new_back_link_location
        root_path
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
        @service = service_class.new(service_params)
      end
  
      # Only allow a list of trusted parameters through.
      def service_params
        if respond_to?(:permitted_params, true)
          # add permitted_params aliasing service_params adding a deprecation warning
          ActiveSupport::Deprecation.warn("The `permitted_params` method is deprecated and will be removed in the next major version. Please use `service_params` instead.", caller)
          return permitted_params
        end

        # params.require(service_class.model_name.singular).permit(*service_class.permitted_params)
        raise "Please implement the `service_params` method in your controller."
      end
    end
  end
end
