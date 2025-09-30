module Rao
  # Provides bulk deletion functionality for resource controllers with batch operations support.
  #
  # This concern adds the ability to delete multiple resources in a single operation,
  # with automatic count tracking, flash messages, and intelligent redirects.
  # It's designed for admin interfaces where bulk operations are common and necessary.
  #
  # @example Basic usage with user management
  #   class UsersController < ApplicationController
  #     include Rao::ResourcesController::BatchActionsConcern
  #
  #     def self.resource_class
  #       User
  #     end
  #   end
  #
  #   # Result: Efficient bulk deletion
  #   # POST /users/destroy_many?ids[]=1&ids[]=2&ids[]=3
  #   # - Deletes multiple users in single database transaction
  #   # - Shows success message with count of deleted items
  #   # - Redirects back to collection with updated list
  #   # - Handles large batches efficiently
  #
  # @example Custom redirect location
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::BatchActionsConcern
  #
  #     private
  #
  #     def after_destroy_many_location
  #       admin_posts_path  # Custom redirect after bulk deletion
  #     end
  #   end
  #
  #   # Result: Enhanced admin workflow
  #   # - Users stay in admin interface after bulk operations
  #   # - Maintains context of admin panel navigation
  #   # - Provides consistent user experience
  #
  # @example Routes configuration
  #   # config/routes.rb
  #   resources :users do
  #     post :destroy_many, on: :collection
  #   end
  #
  #   # Result: RESTful bulk operations
  #   # - Clean URL structure for batch operations
  #   # - Follows Rails conventions for collection actions
  #   # - Integrates seamlessly with existing resource routes
  #
  # @note Requires proper route configuration for collection actions
  # @see https://guides.rubyonrails.org/routing.html#adding-more-restful-actions Rails routing guide
  #
  module ResourcesController::BatchActionsConcern
    def destroy_many
      @collection = load_collection_scope.where(id: params[:ids])
      count = @collection.count
      @collection.destroy_all

      default_message = t(".success", **inflections.merge(count: count, raise: false))
      respond_with @collection,
        location: after_destroy_many_location,
        notice: t("rao.resources_controller.batch_actions_concern.destroy_many.success", **inflections.merge(count: count, default: default_message))
    end

    private

    def after_destroy_many_location
      collection_path
    end
  end
end
