module Rao
  module ViewHelper
    # Example:
    #
    #     # app/view_helpers/unit_view_helper.rb
    #     class UnitViewHelper < ViewHelper::Base
    #       def cent_per_kwh(value)
    #         "#{value} ct/kWh"
    #       end
    #     end
    #
    #     # app/controllers/application_controller.rb
    #     class ApplicationController < ActionController::Base
    #       view_helper UnitViewHelper, as: :unit_helper
    #     end
    #
    #     # app/views/foo.html.erb
    #     <%= unit_helper(self).cent_per_kwh(4.52) %>
    #     => "4.52 ct/kWh"
    #
    class Base
      def initialize(context)
        @context = context
      end

      private

      def c
        @context
      end

      def render(locals = {})
        c.render partial: "/#{self.class.name.underscore}/#{caller_locations(1,1)[0].label}", locals: locals
      end

      # You can use scoped translations by using the dot notation.
      #
      # Example:
      #
      #     # app/view_helpers/blog_view_helper.rb
      #     class BlogViewHelper < Rao::ViewHelper::Base
      #       def title
      #         t('.title')
      #       end
      #     end
      #
      #     # config/locales/en.yml
      #     en:
      #       view_helpers:
      #         blog_view_helper:
      #           title: 'Posts'
      #
      #     blog_view_helper(self).title
      #       => "Posts"
      #
      module I18nConcern
        def t(key, options = {})
          if key.start_with?('.')
            I18n.t("view_helpers.#{self.class.name.underscore}.#{key}", options)
          else
            I18n.t(key, options)
          end
        end
      end

      include I18nConcern
    end
  end
end