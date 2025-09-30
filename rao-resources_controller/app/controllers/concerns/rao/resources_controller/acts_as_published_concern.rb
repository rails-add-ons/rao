module Rao
  # Provides publishing and unpublishing functionality for resource controllers with content management features.
  #
  # This concern adds the ability to toggle, publish, and unpublish resources through HTTP requests,
  # with support for both individual and bulk operations. It provides automatic flash messages,
  # intelligent redirects, and seamless integration with content management workflows.
  #
  # @example Basic usage with content management
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::ActsAsPublishedConcern
  #
  #     def self.resource_class
  #       Post
  #     end
  #   end
  #
  #   # Result: Complete publishing workflow
  #   # POST /posts/1/toggle_published
  #   # - Toggles published state of individual post
  #   # - Shows success message with resource name and action taken
  #   # - Redirects back to previous page with updated state
  #   # - Handles both publish and unpublish operations automatically
  #
  # @example Bulk publishing operations
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::ActsAsPublishedConcern
  #   end
  #
  #   # Result: Efficient bulk content management
  #   # POST /posts/publish_many?ids[]=1&ids[]=2&ids[]=3
  #   # - Publishes multiple posts in single operation
  #   # - Shows success message with all affected resource names
  #   # - Dramatically reduces time for content managers
  #   # - Maintains audit trail of bulk operations
  #
  # @example Custom redirect behavior
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::ActsAsPublishedConcern
  #
  #     private
  #
  #     def after_publish_toggle_location
  #       post_path(@resource)  # Stay on the post's show page
  #     end
  #   end
  #
  #   # Result: Enhanced user experience with contextual redirects
  #   # - Users see immediate results of their actions
  #   # - Maintains context of what they were editing
  #   # - Reduces navigation overhead for content managers
  #
  # @example Routes configuration
  #   # config/routes.rb
  #   resources :posts do
  #     post :toggle_published, on: :member
  #     post :publish_many, on: :collection
  #     post :unpublish_many, on: :collection
  #   end
  #
  #   # Result: Complete publishing API
  #   # - Individual toggle: POST /posts/1/toggle_published
  #   # - Bulk publish: POST /posts/publish_many
  #   # - Bulk unpublish: POST /posts/unpublish_many
  #   # - Clean, RESTful interface for all publishing operations
  #
  # @note Requires your model to implement publish!, unpublish!, toggle_published! methods and published? predicate
  # @see https://github.com/rails-add-ons/acts_as_published ActsAsPublished documentation
  #
  module ResourcesController::ActsAsPublishedConcern
    extend ActiveSupport::Concern

    def publish_many
      @collection = load_collection_scope.find(params[:ids])
      @collection.map(&:publish!)

      resource_labels = []
      @collection.each do |resource|
        [:human, :name, :title, :email, :to_s].each do |method_name|
          if resource.respond_to?(method_name)
            resource_labels << resource.send(method_name)
            break
          end
        end
      end

      notice = I18n.t("acts_as_published.notices.published_many", names: resource_labels.to_sentence)
      flash[:notice] = notice
      redirect_to(after_publish_toggle_location)
    end

    def unpublish_many
      @collection = load_collection_scope.find(params[:ids])
      @collection.map(&:unpublish!)

      resource_labels = []
      @collection.each do |resource|
        [:human, :name, :title, :email, :to_s].each do |method_name|
          if resource.respond_to?(method_name)
            resource_labels << resource.send(method_name)
            break
          end
        end
      end

      notice = I18n.t("acts_as_published.notices.unpublished_many", names: resource_labels.to_sentence)
      flash[:notice] = notice
      redirect_to(after_publish_toggle_location)
    end

    def toggle_published
      @resource = load_resource
      @resource.toggle_published!

      action_taken = @resource.published? ? "published" : "unpublished"

      resource_label = nil
      [:human, :name, :title, :email, :to_s].each do |method_name|
        if @resource.respond_to?(method_name)
          resource_label = @resource.send(method_name)
          break
        end
      end

      flash[:notice] = I18n.t("acts_as_published.notices.#{action_taken}", name: resource_label)
      redirect_to(after_publish_toggle_location)
    end

    private

    def after_publish_toggle_location
      redirect_back(fallback_location: main_app.root_path)
    end
  end
end
