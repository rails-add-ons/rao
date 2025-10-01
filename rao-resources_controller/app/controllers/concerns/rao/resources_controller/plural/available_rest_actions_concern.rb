module Rao
  module ResourcesController
    module Plural
      # You can exclude available actions so that buttons to that action are not included
      # in the UI.
      #
      # Example:
      #
      #     # app/controllers/posts_controller.rb
      #     class PostsController < ApplicationController
      #       include Rao::ResourcesController::Plural::AvailableRestActionsConcern
      #
      #       def self.available_rest_actions
      #         super - %i(edit new)
      #       end
      #     end
      module AvailableRestActionsConcern
        extend ActiveSupport::Concern

        included do
          helper_method :available_rest_actions
        end

        module ClassMethods
          def available_rest_actions
            %i(index new create show edit update destroy)
          end
        end

        def available_rest_actions
          self.class.available_rest_actions
        end
      end
    end
  end
end