module Rao
  module ServiceController
    # Provides inflection and humanization functionality for service controller views.
    #
    # This concern adds helper methods to make service class names and other
    # service-related terms available in a human-readable format for use in
    # controller views. It automatically creates inflections for service names
    # and other service-related terminology.
    #
    # The concern provides:
    # - Human-readable service names via #inflections helper
    # - Automatic helper method registration for view access
    # - Integration with ActiveModel naming conventions
    #
    # @example Basic usage in controller
    #   class UsersController < ApplicationController
    #     include Rao::ServiceController::InflectionsConcern
    #     include Rao::ServiceController::RestActionsConcern
    #     
    #     def service_class
    #       CreateUserService
    #     end
    #   end
    #
     # @example Usage in views
     #   <!-- In app/views/users/new.html.haml -->
     #   %h1= t(".title", **inflections)
     #   <!-- Uses inflections in translation, outputs humanized service name -->
    #
    # @example Custom inflections
    #   # Override in controller to add custom inflections
    #   class UsersController < ApplicationController
    #     include Rao::ServiceController::InflectionsConcern
    #     
    #     private
    #     
    #     def inflections
    #       super.merge(
    #         page_title: "User Management",
    #         action_button: "Create New User"
    #       )
    #     end
    #   end
    #
    # @see ActiveModel::Naming For model name humanization
    module InflectionsConcern
      extend ActiveSupport::Concern

      included do
        helper_method :inflections
      end
  
      private
  
      # Returns a hash of inflections for use in views.
      #
      # This method provides human-readable versions of service-related terms
      # that can be used in controller views. It automatically humanizes
      # the service class name using ActiveModel naming conventions.
      #
      # @return [Hash] Hash containing inflections for view usage
      # @option return [String] :service_name Human-readable service name
      #
      # @example Basic usage
      #   inflections
      #   # => { service_name: "Create user" }
      #
      # @example In view template with translation
      #   %h1= t(".title", **inflections)
      #   <!-- Passes inflections to translation helper -->
      #
      # @example Custom extension
      #   def inflections
      #     super.merge(
      #       service_name: service_class.model_name.human,
      #       custom_term: "Custom Value"
      #     )
      #   end
      def inflections
        {
          service_name: service_class.model_name.human
        }
      end
    end
  end
end
