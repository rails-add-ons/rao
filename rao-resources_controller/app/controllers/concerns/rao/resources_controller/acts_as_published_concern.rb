module Rao
  # Example usage:
  #
  #   # app/controllers/posts_controller.rb
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::ActsAsPublishedConcern
  #   end
  #
  #   # config/routes.rb
  #   Rails.application.routes.draw do
  #     resources :posts do
  #       post :toggle_published, on: :member
  #       post :publish_many, on: :collection
  #       post :unpublish_many, on: :collection
  #     end
  #   end
  #
  # This concern adds actions for toggling, publishing, and unpublishing resources.
  # Make sure your resource model implements `publish!`, `unpublish!`, and `toggle_published!` methods,
  # and has a `published?` predicate.
  #
  # To customize the redirect location after publishing or unpublishing actions,
  # override the `after_publish_toggle_location` method in your controller.
  #
  # Example:
  #   def after_publish_toggle_location
  #     post_path(@resource) # Redirect to the post's show page after publishing/unpublishing
  #   end
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

      action_taken = @resource.published? ? 'published' : 'unpublished'
      
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
