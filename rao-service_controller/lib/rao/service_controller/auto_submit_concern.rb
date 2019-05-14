module Rao
  module ServiceController
    # Handles automatic form submits.
    #
    # Prerequisites:
    #
    # * jQuery
    # * Rao::ViewHelper
    #
    # Include the javascript:
    #
    #     # app/assets/javascripts/application.js
    #     //= require rao/service_controller/application/auto_submit
    #
    # Example:
    #
    #     # app/controllers/posts_controller.rb
    #     require 'rao/service_controller/auto_submit_concern'
    #     require 'rao/service_controller/auto_submit_view_helper'
    #
    #     class PostsController < ApplicationController
    #       include Rao::ServiceController::AutoSubmitConcern
    #       view_helper Rao::ServiceController::AutoSubmitViewHelper, as: :auto_submit_helper
    #
    #       # ...
    #
    #       private
    #
    #       def auto_submit?
    #         true
    #       end
    #     end
    #
    #     # app/views/posts/new.html.haml
    #     = form_for(...) do |f|
    #       = auto_submit_helper(self).form_field
    #
    module AutoSubmitConcern
      extend ActiveSupport::Concern

      private

      # Overwrite this method to control the auto submission of the form.
      def auto_submit?
        false
      end

      def auto_submit_now?
        auto_submit? && action_name == 'new'
      end
    end
  end
end