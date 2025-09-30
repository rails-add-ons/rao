module Rao
  # Provides drag-and-drop repositioning functionality for ordered resource collections using ActsAsList.
  #
  # This concern adds the ability to reorder items in a list through drag-and-drop operations,
  # with automatic position updates, flash messages, and intelligent positioning logic.
  # It integrates with the ActsAsList gem to provide seamless list management in web applications.
  #
  # @example Basic usage with ordered posts
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::ActsAsListConcern
  #
  #     def self.resource_class
  #       Post
  #     end
  #   end
  #
  #   # Result: Automatic drag-and-drop repositioning
  #   # POST /posts/1/reposition?dropped_id=3
  #   # - Moves post #1 to the position of post #3
  #   # - Automatically adjusts all other positions
  #   # - Shows success message with resource names
  #   # - Redirects back to collection with updated order
  #
  # @example Custom redirect location
  #   class CategoriesController < ApplicationController
  #     include Rao::ResourcesController::ActsAsListConcern
  #
  #     private
  #
  #     def after_reposition_location
  #       admin_categories_path  # Custom redirect after repositioning
  #     end
  #   end
  #
  #   # Result: Enhanced user experience with custom redirects
  #   # - Users stay in admin interface after reordering
  #   # - Maintains context of where they were working
  #   # - Provides consistent navigation flow
  #
  # @example Routes configuration
  #   # config/routes.rb
  #   resources :posts do
  #     post :reposition, on: :member
  #   end
  #
  #   # Result: RESTful route for repositioning
  #   # - Clean URL structure for drag-and-drop operations
  #   # - Follows Rails conventions for member actions
  #   # - Integrates with existing resource routes
  #
  # @note Requires ActsAsList gem and position column on your models
  # @see https://github.com/swanandp/acts_as_list ActsAsList documentation
  # @see https://github.com/swanandp/acts_as_list/wiki/Usage ActsAsList usage guide
  #
  module ResourcesController::ActsAsListConcern
    extend ActiveSupport::Concern

    def reposition
      @resource = load_resource
      @dropped_resource = load_resource_scope.find(params[:dropped_id])
      @dropped_resource.set_list_position(@resource.position)
      position = (@dropped_resource.position < @resource.position) ? :before : :after

      label_methods = [:human, :name, :title, :email, :to_s]

      target_resource_label = nil
      label_methods.each do |method_name|
        if @resource.respond_to?(method_name)
          target_resource_label = @resource.send(method_name)
          break
        end
      end

      inserted_resource_label = nil
      label_methods.each do |method_name|
        if @dropped_resource.respond_to?(method_name)
          inserted_resource_label = @dropped_resource.send(method_name)
          break
        end
      end

      redirect_to after_reposition_location, notice: I18n.t("acts_as_list.flash.actions.reposition.inserted_#{position}", target_resource: target_resource_label, inserted_resource: inserted_resource_label)
    end

    private

    def after_reposition_location
      collection_path
    end
  end
end
