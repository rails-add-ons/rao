module Rao
  module ResourcesController
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
        before_action :load_collection, only: %i[ index ]
        before_action :load_resource, only: %i[ show edit update destroy ]
        before_action :initialize_resource, only: %i[ new ]
        before_action :initialize_resource_for_create, only: %i[ create ]

        helper Rao::Component::ApplicationHelper
      end

      # GET /posts or /posts.json
      def index
      end
    
      # GET /posts/1 or /posts/1.json
      def show
      end
    
      # GET /posts/new
      def new
        @resource = resource_class.new
      end
    
      # GET /posts/1/edit
      def edit
      end
    
      # POST /posts or /posts.json
      def create
        @resource = resource_class.new(resource_params)
    
        respond_to do |format|
          if @resource.save
            format.html { redirect_to @resource, notice: "#{resource_class.model_name.human} was successfully created." }
            format.json { render :show, status: :created, location: @resource }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @resource.errors, status: :unprocessable_entity }
          end
        end
      end
    
      # PATCH/PUT /posts/1 or /posts/1.json
      def update
        respond_to do |format|
          if @resource.update(resource_params)
            format.html { redirect_to resource_path(@resource), notice: "#{resource_class.model_name.human} was successfully updated." }
            format.json { render :show, status: :ok, location: @resource }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @resource.errors, status: :unprocessable_entity }
          end
        end
      end
    
      # DELETE /posts/1 or /posts/1.json
      def destroy
        @resource.destroy!
    
        respond_to do |format|
          format.html { redirect_to collection_path, status: :see_other, notice: "#{resource_class.model_name.human} was successfully destroyed." }
          format.json { head :no_content }
        end
      end
    
      private

      # Override this method in your controller to provide a custom back link location.
      def edit_back_link_location
        resource_path(@resource)
      end
      
      # Override this method in your controller to provide a custom back link location.
      def index_back_link_location
        root_path
      end
      
      # Override this method in your controller to provide a custom back link location.
      def new_back_link_location
        collection_path
      end
      
      # Override this method in your controller to provide a custom back link location. 
      def show_back_link_location
        collection_path
      end
      

      # Override this method in your controller to provide a custom collection load scope.
      def load_collection_scope
        resource_class
      end
  
      # Override this method in your controller to provide custom collection loading.
      def load_collection
        @collection = load_collection_scope.all
      end

      # Override this method in your controller to provide a custom resource load scope.
      def load_resource_scope
        resource_class
      end

      # Override this method in your controller to provide custom resource loading.
      def load_resource
        @resource = load_resource_scope.find(params.expect(:id))
      end

      # Override this method in your controller to initialize a new resource in a custom way.
      def initialize_resource
        @resource = resource_class.new
      end
  
      # Override this method in your controller to initialize a new resource for create in a custom way.
      def initialize_resource_for_create
        @resource = resource_class.new(resource_params)
      end
  
      # Only allow a list of trusted parameters through.
      def resource_params
        if respond_to?(:permitted_params, true)
          # add permitted_params aliasing resource_params adding a deprecation warning
          ActiveSupport::Deprecation.warn("The `permitted_params` method is deprecated and will be removed in the next major version. Please use `resource_params` instead.", caller)
          return permitted_params
        end

        # params.require(resource_class.model_name.singular).permit(*resource_class.permitted_params)
        raise "Please implement the `resource_params` method in your controller."
      end
    end
  end
end
