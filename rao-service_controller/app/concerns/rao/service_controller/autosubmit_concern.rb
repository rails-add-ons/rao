module Rao
  # Handles automatic form submits.
  #
  # Prerequisites:
  #
  # Include the javascript:
  #
  #     # app/assets/javascripts/application.js
  #     //= require rao/service_controller/application/autosubmit
  #
  # Example:
  #
  #     # app/controllers/posts_controller.rb
  #     class PostsController < ApplicationController
  #       include Rao::ServiceController::AutosubmitConcern
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
  #       = f.input :autosubmit, as: :autosubmit
  #
  module ServiceController::AutosubmitConcern
    extend ActiveSupport::Concern

    included do
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
