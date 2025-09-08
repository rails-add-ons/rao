module Rao
  module ResourcesController
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

          respond_to :html, :turbo_stream, :json
          responders :flash

          before_action :load_resource, only: [:show, :edit, :destroy, :update]
          before_action :initialize_resource, only: [:new]
          before_action :initialize_resource_for_create, only: [:create]
          before_action :before_rest_action

          helper Rao::Component::ApplicationHelper
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

        # POST /profile or /profile.json
        # Creates a new resource with the provided parameters.
        # Redirects to a custom location if after_create_location is not nil,
        # otherwise uses the default respond_with behavior.
        def create
          @resource.save
          respond_with(@resource, location: after_create_location || @resource)
          # respond_to do |format|
          #   if @resource.save
          #     format.html { redirect_to @resource, notice: "#{resource_class.model_name.human} was successfully created." }
          #     format.json { render :show, status: :created, location: after_create_location || @resource }
          #   else
          #     format.html { render :new, status: :unprocessable_entity }
          #     format.json { render json: @resource.errors, status: :unprocessable_entity }
          #   end
          # end
        end

        # PATCH/PUT /profile
        # Updates the existing resource with the provided parameters.
        # Redirects to a custom location if after_update_location is not nil,
        # otherwise uses the default respond_with behavior.
        def update
          @resource.update(resource_params)
          respond_with(@resource, location: after_update_location || @resource)

          # respond_to do |format|
          #   if @resource.update(resource_params)
          #     format.html { redirect_to @resource, notice: "#{resource_class.model_name.human} was successfully updated." }
          #     format.json { render :show, status: :ok, location: after_update_location || @resource }
          #   else
          #     format.html { render :edit, status: :unprocessable_entity }
          #     format.json { render json: @resource.errors, status: :unprocessable_entity }
          #   end
          # end
        end

        # DELETE /profile
        # Destroys the existing resource.
        # Redirects to a custom location if after_destroy_location is not nil,
        # otherwise uses the default respond_with behavior.
        def destroy
          @resource.destroy
          # this should call user_url and not users_url
          respond_with(@resource, location: (after_destroy_location || root_path))
          # respond_with(@resource, location: (after_destroy_location || @resource))

          # respond_to do |format|
          #   format.html { redirect_to after_destroy_location || @resource, status: :see_other, notice: "#{resource_class.model_name.human} was successfully destroyed." }
          #   format.json { head :no_content }
          # end
        end

        private

        def before_rest_action; end

        def after_create_location
          nil
        end

        def after_destroy_location
          nil
        end

        def after_update_location
          nil
        end

        # Override this method in your controller to provide a custom back link location.
        def edit_back_link_location
          resource_path(@resource)
        end
        
        # Override this method in your controller to provide a custom back link location.
        def new_back_link_location
          root_path
        end
        
        # Override this method in your controller to provide a custom back link location. 
        def show_back_link_location
          root_path
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
end
