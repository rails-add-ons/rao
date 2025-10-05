module Rao
  module Service
    # Provides internationalization (i18n) support for service objects.
    #
    # This concern adds translation functionality to service objects, allowing them
    # to use localized strings for error messages, labels, and other text content.
    # Translations are automatically namespaced under the service class name to
    # avoid conflicts and provide organized translation keys.
    #
    # Translation keys follow the pattern:
    # `activemodel.{service_class_name_underscored}{key}`
    #
    # @example Basic usage
    #   class CreateUserService < Rao::Service::Base
    #     private
    #
    #     def _perform
    #       if invalid_email?
    #         add_error(:email, t('.invalid_email'))
    #       end
    #     end
    #   end
    #
    #   # Translation file (config/locales/en.yml):
    #   # en:
    #   #   activemodel:
    #   #     create_user_service:
    #   #       invalid_email: "The email address is not valid"
    #   #       success_message: "User created successfully"
    #
    # @example With interpolation
    #   class UpdateProfileService < Rao::Service::Base
    #     attr_accessor :user_name
    #
    #     def after_perform
    #       add_message(t('.profile_updated', name: user_name))
    #     end
    #   end
    #
    #   # Translation file:
    #   # en:
    #   #   activemodel:
    #   #     update_profile_service:
    #   #       profile_updated: "Profile updated for %{name}"
    module Base::I18nConcern
      extend ActiveSupport::Concern

      # Translates a key within the service's translation namespace.
      #
      # This method automatically prefixes the translation key with the service's
      # class name (underscored) under the `activemodel` namespace. This ensures
      # that translations are organized by service and prevents key conflicts.
      #
      # @param key [String] The translation key (can start with '.' for relative keys)
      # @param options [Hash] Options to pass to I18n.t (interpolation values, etc.)
      # @return [String] The translated string
      #
      # @example Basic translation
      #   t('.success_message')
      #   # Looks up: activemodel.create_user_service.success_message
      #
      # @example With interpolation
      #   t('.welcome', name: user.name)
      #   # Looks up: activemodel.create_user_service.welcome
      #   # With interpolation: { name: user.name }
      #
      # @example Absolute key (starts without '.')
      #   t('common.buttons.save')
      #   # Looks up: activemodel.create_user_service.common.buttons.save
      def t(key, options = {})
        I18n.t("activemodel.#{self.class.name.underscore}#{key}", **options)
      end
    end
  end
end
