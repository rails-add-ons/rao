module Rao
  module ServiceController
    # This module provides URL and path helper methods for serviceful routes in a Rails controller.
    # It includes methods to generate paths and URLs for service collections, individual services,
    # and actions like new and edit.
    #
    # Example usage:
    #
    # class PostsController < ApplicationController
    #   include Rao::ResourcesController::RestResourcesUrlsConcern
    #
    #   private
    #
    #   def service_namespace
    #     :admin
    #   end
    #
    #   def service_router
    #     main_app
    #   end
    # end
    #
    # In the above example, the `PostsController` includes the `RestResourcesUrlsConcern` module,
    # which provides helper methods for generating paths and URLs for the `Post` service.
    # The `service_namespace` method is overridden to specify the namespace as `:admin`,
    # and the `service_router` method is overridden to use the `main_app` router context.
    #
    # Available helper methods:
    # - collection_path(options = {}): Returns the path for the service collection (e.g., /posts).
    # - edit_service_path(service, options = {}): Returns the path for editing a specific service (e.g., /posts/1/edit).
    # - new_service_path(options = {}): Returns the path for creating a new service (e.g., /posts/new).
    # - service_path(service, options = {}): Returns the path for a specific service (e.g., /posts/1).
    # - collection_url(options = {}): Returns the URL for the service collection (e.g., https://example.com/posts).
    # - edit_service_url(service, options = {}): Returns the URL for editing a specific service (e.g., https://example.com/posts/1/edit).
    # - new_service_url(options = {}): Returns the URL for creating a new service (e.g., https://example.com/posts/new).
    # - service_url(service, options = {}): Returns the URL for a specific service (e.g., https://example.com/posts/1).
    #
    # Overrideable methods:
    # - service_namespace: Override to define the namespace for services, if needed (e.g., :admin).
    # - service_router: Override to define the router context, defaulting to `self`.
    #
    module RestUrlsConcern
      extend ActiveSupport::Concern

      included do
        helper_method :new_service_path, :service_path
      end

      private

      # Returns the path for creating a new service (e.g., /posts/new).
      def new_service_path(options = {})
        service_router.polymorphic_path([:new, service_namespace, service_class].flatten.compact, options)
        # service_router.new_polymorphic_path([service_namespace, service_class].flatten.compact, options)
      end

      # Returns the path for a specific service (e.g., /posts/1).
      def service_path(service, options = {})
        service_router.polymorphic_path([service_namespace, service].flatten.compact, options)
      end

      # Override to define the namespace for services, if needed (e.g., :admin).
      def service_namespace
        nil # Default to no namespace. Override in the controller if needed.
      end

      # Returns the router context, defaulting to `self`.
      # Override this method if routing requires a different context.
      def service_router
        self
      end
    end
  end
end
