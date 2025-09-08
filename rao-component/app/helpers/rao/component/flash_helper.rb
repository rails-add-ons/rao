module Rao
  module Component
    # Provides helpers to render flash messages.
    # To use it you have to add it to your controller:
    #
    # Example:
    #
    #     class PostsController < ApplicationController
    #       #...
    #       helper Rao::Component::FlashHelper
    #     end
    #
    module FlashHelper
      # Renders the flash messages.
      #
      # Example:
      #
      #     <%= flash_messages.render %>
      #
      def flash_messages(options = {})
        Rao::Component::Flash.new(self, options)
      end
    end
  end
end
