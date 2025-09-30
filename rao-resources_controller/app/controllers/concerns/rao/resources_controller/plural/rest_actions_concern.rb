module Rao
  module ResourcesController
    module Plural
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

          before_action :load_collection, only: %i[index]
          before_action :load_resource, only: %i[show edit update destroy]
          before_action :initialize_resource, only: %i[new]
          before_action :initialize_resource_for_create, only: %i[create]

          helper Rao::Component::ApplicationHelper
          helper_method :resource_namespace
        end

        # GET /posts or /posts.json
        def index
        end

        # GET /posts/1 or /posts/1.json
        def show
        end

        # GET /posts/new
        def new
        end

        # GET /posts/1/edit
        def edit
        end

        # POST /posts or /posts.json
        def create
          if @resource.save
            respond_to do |format|
              format.html { respond_with(@resource, location: after_create_location || @resource) }
              format.json { respond_with(@resource) }
              format.turbo_stream { set_flash_message!(@resource, :create, :notice) && redirect_to(after_create_location || @resource) }
            end
          else
            respond_to do |format|
              format.html { respond_with(@resource) }
              format.json { respond_with(@resource) }
              format.turbo_stream do
                render turbo_stream: turbo_stream.replace(
                  dom_id(@resource, :form),
                  partial: "form_tag",
                  locals: {resource: @resource}
                )
              end
            end
          end
        end

        # PATCH/PUT /posts/1 or /posts/1.json
        def update
          if @resource.update(resource_params)
            respond_to do |format|
              format.html { respond_with(@resource, location: after_update_location || @resource) } # renders :edit with 422
              format.json { respond_with(@resource) }
              format.turbo_stream { set_flash_message!(@resource, :update, :notice) && redirect_to(after_update_location || @resource) }
            end
          else
            respond_to do |format|
              format.html { respond_with(@resource) } # renders :edit with 422
              format.json { respond_with(@resource) }
              format.turbo_stream do
                render turbo_stream: turbo_stream.replace(
                  dom_id(@resource, :form),
                  partial: "form_tag",
                  locals: {resource: @resource}
                )
              end
            end
          end
        end

        # DELETE /posts/1 or /posts/1.json
        def destroy
          @resource.destroy
          respond_to do |format|
            format.html { respond_with(@resource, location: after_destroy_location || collection_path) }
            format.json { head :no_content }
            format.turbo_stream { set_flash_message!(@resource, :destroy, :notice) && redirect_to(after_destroy_location || collection_path, status: :see_other) }
          end
        end
        # def destroy
        #   @resource.destroy!
        #   respond_to do |format|
        #     format.html { respond_with(@resource, location: after_destroy_location || collection_path) }
        #     format.json { head :no_content }
        #     format.turbo_stream { set_flash_message!(@resource, :destroy, :notice) && redirect_to(after_destroy_location || collection_path, status: :see_other) }
        #   end
        # end

        private

        def set_flash_message!(resource, action, status = :notice)
          # get a anonymous class and include the Responders::FlashResponder module
          anonymous_class = Class.new(ActionController::Responder) { include Responders::FlashResponder }
          f = anonymous_class.new(self, [resource])
          f.send(:set_flash_message!)
        end

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
            ActiveSupport::Deprecation.new("1.0.0", "rao-resources_controller").warn("The `permitted_params` method is deprecated and will be removed in the next major version. Please use `resource_params` instead.", caller_locations)
            return permitted_params
          end

          # params.require(resource_class.model_name.singular).permit(*resource_class.permitted_params)
          raise "Please implement the `resource_params` method in your controller."
        end
      end
    end
  end
end
