module Rao
  # Usage:
  #
  #     # app/controllers/posts_controller.rb
  #     class PostsController < ApplicationController
  #       include Rao::ResourcesController::ActsAsListConcern
  #     end
  #
  #     # config/routes.rb
  #     Rails.application.routes.draw do
  #       resources :posts do
  #         post :reposition, on: :member
  #       end
  #     end
  #
  module ResourcesController::ActsAsListConcern
    extend ActiveSupport::Concern

    def reposition
      @resource = load_resource
      @dropped_resource = load_resource_scope.find(params[:dropped_id])
      @dropped_resource.set_list_position(@resource.position)
      position = @dropped_resource.position < @resource.position ? :before : :after

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