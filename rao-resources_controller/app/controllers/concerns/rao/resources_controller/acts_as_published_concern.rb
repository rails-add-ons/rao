module Rao
  # Usage:
  #
  #     # app/controllers/posts_controller.rb
  #     class PostsController < ApplicationController
  #       include Rao::ResourcesController::ActsAsPublishedConcern
  #     end
  #
  #     # config/routes.rb
  #     Rails.application.routes.draw do
  #       resources :posts do
  #         post :toggle_published, on: :member
  #       end
  #     end
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
      if Rails.version < '5.0.0'
        redirect_to :back, notice: notice
      else
        flash[:notice] = notice
        redirect_back(fallback_location: main_app.root_path)
      end
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
      if Rails.version < '5.0.0'
        redirect_to :back, notice: notice
      else
        flash[:notice] = notice
        redirect_back(fallback_location: main_app.root_path)
      end
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

      if Rails.version < '5.0.0'
        redirect_to :back, notice: I18n.t("acts_as_published.notices.#{action_taken}", name: resource_label)
      else
        flash[:notice] = I18n.t("acts_as_published.notices.#{action_taken}", name: resource_label)
        redirect_back(fallback_location: main_app.root_path)
      end
    end
  end
end
