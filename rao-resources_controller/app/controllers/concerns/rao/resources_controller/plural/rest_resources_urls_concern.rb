module Rao
  module ResourcesController
    module Plural
      # This module provides URL and path helper methods for resourceful routes in a Rails controller.
      # It includes methods to generate paths and URLs for resource collections, individual resources,
      # and actions like new and edit.
      #
      # Example usage:
      #
      # class PostsController < ApplicationController
      #   include Rao::ResourcesController::RestResourcesUrlsConcern
      #
      #   private
      #
      #   def resource_namespace
      #     :admin
      #   end
      #
      #   def resource_router
      #     main_app
      #   end
      # end
      #
      # In the above example, the `PostsController` includes the `RestResourcesUrlsConcern` module,
      # which provides helper methods for generating paths and URLs for the `Post` resource.
      # The `resource_namespace` method is overridden to specify the namespace as `:admin`,
      # and the `resource_router` method is overridden to use the `main_app` router context.
      #
      # Available helper methods:
      # - collection_path(options = {}): Returns the path for the resource collection (e.g., /posts).
      # - edit_resource_path(resource, options = {}): Returns the path for editing a specific resource (e.g., /posts/1/edit).
      # - new_resource_path(options = {}): Returns the path for creating a new resource (e.g., /posts/new).
      # - resource_path(resource, options = {}): Returns the path for a specific resource (e.g., /posts/1).
      # - collection_url(options = {}): Returns the URL for the resource collection (e.g., https://example.com/posts).
      # - edit_resource_url(resource, options = {}): Returns the URL for editing a specific resource (e.g., https://example.com/posts/1/edit).
      # - new_resource_url(options = {}): Returns the URL for creating a new resource (e.g., https://example.com/posts/new).
      # - resource_url(resource, options = {}): Returns the URL for a specific resource (e.g., https://example.com/posts/1).
      #
      # Overrideable methods:
      # - resource_namespace: Override to define the namespace for resources, if needed (e.g., :admin).
      # - resource_router: Override to define the router context, defaulting to `self`.
      #
      module RestResourcesUrlsConcern
        extend ActiveSupport::Concern

        included do
          helper_method :collection_path, :destroy_resource_path, :edit_resource_path, :new_resource_path, :resource_path
          helper_method :collection_url, :destroy_resource_url, :edit_resource_url, :new_resource_url, :resource_url
        end

        private

        # Returns the path for the resource collection (e.g., /posts).
        def collection_path(options = {})
          resource_router.polymorphic_path([resource_namespace, resource_class].flatten.compact, options)
        end

        # Returns the path for creating the resource (e.g., /posts).
        def create_resource_path(options = {})
          collection_path(options)
        end

        # Returns the path for destroying the resource (e.g., /posts/1).
        def destroy_resource_path(resource, options = {})
          resource_path(resource, options)
        end

        # Returns the path for editing a specific resource (e.g., /posts/1/edit).
        def edit_resource_path(resource, options = {})
          resource_router.edit_polymorphic_path([resource_namespace, resource].flatten.compact, options)
        end

        # Returns the path for creating a new resource (e.g., /posts/new).
        def new_resource_path(options = {})
          resource_router.new_polymorphic_path([resource_namespace, resource_class].flatten.compact, options)
        end

        # Returns the path for a specific resource (e.g., /posts/1).
        def resource_path(resource, options = {})
          resource_router.polymorphic_path([resource_namespace, resource].flatten.compact, options)
        end

        # Returns the path for updating a specific resource (e.g., /posts/1).
        def update_resource_path(resource, options = {})
          resource_path(resource, options)
        end

        # Returns the path for the resource collection (e.g., /posts).
        def collection_url(options = {})
          collection_path(options.merge(only_path: false))
        end

        # Returns the url for creating the resource (e.g., /posts).
        def create_resource_url(options = {})
          create_resource_path(options.merge(only_path: false))
        end

        # Returns the url for destroying the resource (e.g., /posts/1).
        def destroy_resource_url(resource, options = {})
          destroy_resource_path(resource, options.merge(only_path: false))
        end

        # Returns the url for editing a specific resource (e.g., /posts/1/edit).
        def edit_resource_url(resource, options = {})
          edit_resource_path(resource, options.merge(only_path: false))
        end

        # Returns the url for creating a new resource (e.g., /posts/new).
        def new_resource_url(options = {})
          new_resource_path(options.merge(only_path: false))
        end

        # Returns the url for a specific resource (e.g., /posts/1).
        def resource_url(resource, options = {})
          resource_path(resource, options.merge(only_path: false))
        end

        # Returns the url for updating a specific resource (e.g., /posts/1).
        def update_resource_url(resource, options = {})
          update_resource_path(resource, options.merge(only_path: false))
        end

        # Override to define the namespace for resources, if needed (e.g., :admin).
        def resource_namespace
          nil # Default to no namespace. Override in the controller if needed.
        end

        # Returns the router context, defaulting to `self`.
        # Override this method if routing requires a different context.
        def resource_router
          self
        end
      end
    end
  end
end
