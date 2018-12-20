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
    end
  end
end