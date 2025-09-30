module Rao
  module ResourcesController
    # Provides resource name inflections for resource controllers with internationalization support.
    #
    # This concern automatically provides human-readable resource names in both singular and plural
    # forms, making it easy to display proper labels in views, flash messages, and form elements.
    # It integrates with Rails' I18n system for proper internationalization support.
    #
    # @example Basic usage with resource labels
    #   class PostsController < ApplicationController
    #     include Rao::ResourcesController::ResourceInflectionsConcern
    #     include Rao::ResourcesController::Plural::RestActionsConcern
    #
    #     def self.resource_class
    #       Post
    #     end
    #   end
    #
    #   # Result: Automatic resource name resolution
    #   # - inflections helper method available in views
    #   # - resource_name: "Post" (singular form)
    #   # - collection_name: "Posts" (plural form)
    #   # - Proper I18n integration for multilingual support
    #
    # @example Usage in views and flash messages
    #   # In your views:
    #   # <%= inflections[:resource_name] %>  # "Post"
    #   # <%= inflections[:collection_name] %>  # "Posts"
    #
    #   # In flash messages:
    #   # "Post was successfully created"
    #   # "Posts were successfully deleted"
    #
    #   # Result: Consistent and professional messaging
    #   # - Proper grammar in all user-facing text
    #   # - Consistent terminology across the application
    #   # - Easy maintenance of resource labels
    #   # - Professional appearance in admin interfaces
    #
    # @example Internationalization support
    #   # With proper I18n setup:
    #   # en:
    #   #   activerecord:
    #   #     models:
    #   #       post:
    #   #         one: "Article"
    #   #         other: "Articles"
    #
    #   # Result: Multilingual resource names
    #   # - Automatic translation of resource names
    #   # - Proper pluralization rules for different languages
    #   # - Consistent terminology across all locales
    #   # - Easy maintenance of multilingual applications
    #
    # @example Custom resource name handling
    #   # The concern automatically uses Rails' model_name.human method
    #   # which respects your I18n configuration and model definitions
    #
    #   # Result: Flexible resource naming
    #   # - Respects custom model name configurations
    #   # - Integrates with existing I18n setup
    #   # - Maintains consistency with Rails conventions
    #   # - Easy to override for special cases
    #
    # @note Requires proper I18n configuration for full functionality
    # @see https://guides.rubyonrails.org/i18n.html Rails I18n guide
    # @see https://guides.rubyonrails.org/active_record_basics.html#convention-over-configuration Rails model conventions
    #
    module ResourceInflectionsConcern
      extend ActiveSupport::Concern

      included do
        helper_method :inflections
      end

      private

      def inflections
        {
          resource_name: resource_class.model_name.human,
          collection_name: resource_class.model_name.human(count: :other)
        }
      end
    end
  end
end
