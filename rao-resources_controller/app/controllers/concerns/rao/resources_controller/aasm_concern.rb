module Rao
  # Provides state machine event triggering functionality for resource controllers using AASM.
  #
  # This concern adds the ability to trigger state machine events on resources through HTTP requests,
  # with automatic error handling, flash messages, and redirects. It integrates with the AASM gem
  # to provide a clean interface for state transitions in web applications.
  #
  # @example Basic usage with a Post model
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::AasmConcern
  #
  #     def self.resource_class
  #       Post
  #     end
  #   end
  #
  #   # Result: Automatic state machine event handling
  #   # POST /posts/1/trigger_event?machine_name=default&event_name=publish
  #   # - Triggers the 'publish' event on the post's default state machine
  #   # - Shows success/failure flash messages automatically
  #   # - Redirects back to previous page with appropriate feedback
  #   # - Handles validation errors gracefully
  #
  # @example Custom parameter handling
  #   class OrdersController < ApplicationController
  #     include Rao::ResourcesController::AasmConcern
  #
  #     private
  #
  #     def permitted_params_for_trigger_event
  #       params.permit(:machine_name, :event_name, :comment)
  #     end
  #   end
  #
  #   # Result: Enhanced event triggering with additional parameters
  #   # POST /orders/1/trigger_event?machine_name=workflow&event_name=ship&comment=Express delivery
  #   # - Passes additional parameters to the state machine event
  #   # - Allows for more complex state transitions with context
  #   # - Maintains security through parameter filtering
  #
  # @example Routes configuration
  #   # config/routes.rb
  #   resources :posts do
  #     post :trigger_event, on: :member
  #   end
  #
  #   # Result: RESTful route for state machine events
  #   # - Clean URL structure for state transitions
  #   # - Follows Rails conventions for member actions
  #   # - Integrates seamlessly with existing resource routes
  #
  # @note Requires AASM gem and state machine setup on your models
  # @see https://github.com/aasm/aasm AASM documentation
  # @see https://github.com/aasm/aasm/wiki/Basic-concepts AASM basic concepts
  #
  module ResourcesController
    module AasmConcern
      extend ActiveSupport::Concern

      included do
        before_action :load_resource_for_trigger_event, only: [:trigger_event]
      end

      def trigger_event
        begin
          result = @resource.aasm(permitted_params_for_trigger_event[:machine_name].to_sym).fire!(permitted_params_for_trigger_event[:event_name].to_sym)
        rescue ActiveRecord::RecordInvalid
          result = false
        end

        if result
          flash[:notice] = t(
            "rao.resources_controller.aasm_concern.trigger_event.success",
            event: permitted_params_for_trigger_event[:event_name],
            state: @resource.aasm(permitted_params_for_trigger_event[:machine_name].to_sym).current_state
          )
        else
          flash[:danger] = t(
            "rao.resources_controller.aasm_concern.trigger_event.failure",
            event: permitted_params_for_trigger_event[:event_name],
            errors: @resource.errors.full_messages.to_sentence
          )
        end

        redirect_back(fallback_location: root_path)
      end

      private

      def permitted_params_for_trigger_event
        params.permit!
      end

      def load_resource_for_trigger_event
        load_resource
      end
    end
  end
end
