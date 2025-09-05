module Rao
  module ResourceController
    module Singular
      # This module provides RESTful actions for a Rails controller that manages a single resource,
      # including show, new, edit, create, update, and destroy actions.
      # It is intended to be included in a controller to handle singular resource management tasks.
      #
      # Example usage:
      #
      # class ProfileController < ApplicationController
      #   include Rao::ResourcesController::Singular::ResourcesConcern
      #   include Rao::ResourcesController::Singular::RestActionsConcern
      #
      #   def self.resource_class
      #     User
      #   end
      #
      #   private
      #
      #   def permitted_params
      #     params.require(:user).permit(:name, :email, :bio)
      #   end
      # end
      #
      # The above example assumes you have a `User` model and you want to manage a single user profile
      # using standard RESTful actions. You need to define `resource_class` and `permitted_params` methods
      # in your controller.
      #
      # The following actions are provided:
      # - show: Displays the single resource.
      # - new: Initializes a new resource.
      # - edit: Edits the existing resource.
      # - create: Creates a new resource.
      # - update: Updates the existing resource.
      # - destroy: Deletes the existing resource.
      #
      # The module also provides several hooks that can be overridden in your controller:
      # - load_resource_scope: Customize the scope for loading the resource.
      # - load_resource: Customize the loading of the resource.
      # - initialize_resource: Customize the initialization of a new resource.
      # - initialize_resource_for_create: Customize the initialization of a new resource for creation.
      # - permitted_params: Define the permitted parameters for the resource.
      # - resource_namespace: Define the namespace for the resource (defaults to nil).
      #
      module RestActionsConcern
        extend ActiveSupport::Concern

        included do
          include ActionController::MimeResponds

          respond_to :html
          responders :flash

          if respond_to?(:before_action)
            before_action :load_resource, only: [:show, :edit, :destroy, :update]
            before_action :initialize_resource, only: [:new]
            before_action :initialize_resource_for_create, only: [:create]
            before_action :before_rest_action, if: -> { respond_to?(:before_rest_action, true) }
          else
            before_filter :load_resource, only: [:show, :edit, :destroy, :update]
            before_filter :initialize_resource, only: [:new]
            before_filter :initialize_resource_for_create, only: [:create]
          end

          helper_method :resource_namespace
        end

        # GET /profile/new
        # Initializes a new resource for display in the new form.
        def new; end

        # GET /profile
        # Displays the single resource.
        def show; end

        # GET /profile/edit
        # Displays the edit form for the existing resource.
        def edit; end

        # PATCH/PUT /profile
        # Updates the existing resource with the provided parameters.
        # Redirects to a custom location if after_update_location is defined,
        # otherwise uses the default respond_with behavior.
        def update
          if @resource.send(update_method_name, permitted_params) && respond_to?(:after_update_location, true) && after_update_location.present?
            respond_with(resource_namespace, @resource, location: after_update_location)
          else
            respond_with(resource_namespace, @resource)
          end
        end

        # DELETE /profile
        # Destroys the existing resource.
        # Redirects to a custom location if after_destroy_location is defined,
        # otherwise uses the default respond_with behavior.
        def destroy
          @resource.destroy
          if respond_to?(:after_destroy_location, true) && after_destroy_location.present?
            respond_with(resource_namespace, @resource, location: after_destroy_location)
          else
            respond_with(resource_namespace, @resource)
          end
        end

        # POST /profile
        # Creates a new resource with the provided parameters.
        # Redirects to a custom location if after_create_location is defined,
        # otherwise uses the default respond_with behavior.
        def create
          if @resource.save && respond_to?(:after_create_location, true) && after_create_location.present?
            respond_with(resource_namespace, @resource, location: after_create_location)
          else
            respond_with(resource_namespace, @resource)
          end
        end

        private

        # Returns the appropriate update method name based on Rails version.
        # Uses :update_attributes for Rails < 4, :update for Rails >= 4.
        def update_method_name
          Rails::VERSION::MAJOR < 4 ? :update_attributes : :update
        end

        # Override this method in your controller to provide a custom resource namespace.
        # Defaults to nil, which means no namespace will be used.
        def resource_namespace
          nil
        end

        # Override this method in your controller to provide a custom resource load scope.
        # Defaults to the resource_class.
        def load_resource_scope
          resource_class
        end

        # Override this method in your controller to provide custom resource loading.
        # This method must be implemented in your controller to define how to load @resource.
        def load_resource
          # @resource = load_resource_scope.find(params[:id])
          raise "Please define #load_resource in #{self.class.name} and tell me how to load @resource."
        end

        # Override this method in your controller to initialize a new resource in a custom way.
        # Defaults to creating a new instance of the resource class.
        def initialize_resource
          @resource = resource_class.new
        end

        # Override this method in your controller to initialize a new resource for create in a custom way.
        # Defaults to creating a new instance with the permitted parameters.
        def initialize_resource_for_create
          @resource = resource_class.new(permitted_params)
        end

        # Override this method in your controller to define the permitted parameters for the resource.
        # This method must be implemented in your controller.
        def permitted_params
          raise "not implemented"
        end
      end
    end
  end
end
