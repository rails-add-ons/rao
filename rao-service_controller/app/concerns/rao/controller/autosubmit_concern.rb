module Raos
  module Controller
    # Handles automatic form submits.
    #
    # Prerequisites:
    #
    # Include the javascript:
    #
    #     # app/assets/javascripts/application.js
    #     //= require rails/add_ons/application/autosubmit
    #
    # Example:
    #
    #     # app/controllers/posts_controller.rb
    #     class PostsController < ApplicationController
    #       include AutosubmitConcern
    #
    #       # ...
    #
    #       private
    #
    #       def autosubmit?
    #         true
    #       end
    #     end
    #
    #     # app/views/posts/new.html.haml
    #     = form_for(...) do |f|
    #       = autosubmit
    #
    module AutosubmitConcern
      extend ActiveSupport::Concern

      included do
        helper Rao::AutosubmitHelper
        helper_method :autosubmit?, :autosubmit_now?
      end

      private

      def autosubmit?
        false
      end

      def autosubmit_now?
        autosubmit? && action_name == 'new'
      end
    end
  end
end