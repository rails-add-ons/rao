module Rao
  module Component
    # Usage:
    #
    #     # app/models/cart.rb
    #     class Cart < ActiveRecord::Base
    #       include AASM
    #
    #       aasm do
    #         # ...
    #       end
    #     end
    #
    #     # app/carts/index.html.haml
    #     = collection_table(collection: @carts) do |table|
    #       = table.aasm :default
    #
    # You will have to add a event triggering route to your resource:
    #
    #     # config/routes.rb:
    #     Rails.application.routes do
    #       resources :carts do
    #         post 'trigger_event/:machine_name/:event_name', on: :member, action: 'trigger_event', as: :trigger_event
    #       end
    #       # ...
    #     end
    #
    # Additionally you will need a controller action to handle the triggering of events.
    # Include Rao::ResourcesController::AasmConcern from rao-resources_controller
    # if you don't want to implement it yourself:
    #
    #     # app/controllers/pictures_controller.rb
    #     class PicturesController < ApplicationController
    #       include Rao::ResourcesController::AasmConcern
    #       # ...
    #     end
    #
    module CollectionTable::AasmConcern
      extend ActiveSupport::Concern

      def aasm_state(name = nil, options = {}, &block)
        name = name.presence || :default
        column_name = (name == :default) ? "aasm_state" : "#{name}_state"
        options.reverse_merge!(render_as: :aasm_state, state_machine_name: name)
        column(column_name, options, &block)
      end


      def aasm_actions(name = nil, options = {}, &block)
        name = name.presence || :default
        column_name = (name == :default) ? "aasm_actions" : "#{name}_actions"
        options.reverse_merge!(render_as: :aasm_actions, state_machine_name: name)
        column(column_name, options, &block)
      end
    end
  end
end