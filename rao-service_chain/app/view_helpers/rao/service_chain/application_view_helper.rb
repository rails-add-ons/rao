module Rao
  module ServiceChain
    # Usage:
    #
    #     # app/controllers/application_controller.rb
    #     class ApplicationController < ActionController::Base
    #       view_helper Rao::Service::Chain::ApplicationViewHelper, as: :service_chain_helper
    #     end
    #
    class ApplicationViewHelper < Rao::ViewHelper::Base
      # Usage:
      #
      #     # app/views/layouts/application.html.haml
      #     !!!
      #     %html{ lang: I18n.locale }
      #       %head
      #         /...
      #       %body
      #         = service_chain_helper(self).render_progress(@service_chain)
      #
      def render_progress(service_chain, options = {})
        return if service_chain.nil?
        
        options = default_options.deep_merge(options)
        theme = options.delete(:theme)

        c.render partial: "rao/service_chain/application_view_helper/render_progress/#{theme}", locals: { service_chain: service_chain, options: options }
      end

      private

      def default_options
        {
          theme: :bootstrap4,
          next_steps: { render_as_pending: false, link: true },
          actual_step: { link: false },
          previous_steps: { render_as_pending: true, link: true }
        }
      end
    end
  end
end