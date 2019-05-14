require 'rao/view_helper/base'

module Rao
  module ServiceController
    # Example:
    #
    #     # app/controllers/application_controller.rb
    #     require 'rao/service_controller/auto_submit_view_helper'
    #
    #     class ApplicationController < ActionController::Base
    #       view_helper Rao::ServiceController::AutoSubmitViewHelper, as: :auto_submit_helper
    #     end
    #
    class AutoSubmitViewHelper < Rao::ViewHelper::Base
      # Example:
      #
      #     # app/views/posts/new.html.haml
      #     = form_for(...) do |f|
      #       = auto_submit_helper(self).form_field
      #
      def form_field
        if auto_submit_now?
          c.content_tag(:div, nil, data: { 'auto-submit': true } ).html_safe
        end
      end

      def auto_submit?
        c.controller.send(:auto_submit?)
      end
      
      def auto_submit_now?
        c.controller.send(:auto_submit_now?)
      end
    end
  end
end
