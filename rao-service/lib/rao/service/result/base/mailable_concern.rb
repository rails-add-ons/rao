module Rao
  module Service
    module Result
      # Provides email notification functionality for service result objects.
      #
      # This concern adds the ability to send email notifications when service
      # results are generated, allowing for automatic notifications about
      # service execution outcomes. It integrates with ActionMailer to send
      # formatted result emails with customizable recipients and senders.
      #
      # The concern provides:
      # - Immediate email delivery via #notify_now
      # - Configurable default recipients and senders
      # - Environment-aware notification settings
      # - Integration with Rao::Service::NotificationMailer
      #
      # @example Basic notification usage
      #   class CreateUserService < Rao::Service::Base
      #     # Service implementation
      #   end
      #
      #   class CreateUserService::Result < Rao::Service::Result::Base
      #     include Rao::Service::Result::Base::MailableConcern
      #     
      #     attr_accessor :user
      #   end
      #
      #   # Send notification with default recipient
      #   result = CreateUserService.call(user_data: {...})
      #   result.notify_now if result.success?
      #
      # @example Custom recipient
      #   result = CreateUserService.call(user_data: {...})
      #   result.notify_now("admin@example.com")
      #
      # @example In service callback
      #   class ProcessOrderService < Rao::Service::Base
      #     def after_perform
      #       result.notify_now(customer.email) if result.success?
      #     end
      #   end
      #
      # @note This concern is only included when Rails is present in the application
      # @see Rao::Service::NotificationMailer The mailer class that handles email delivery
      # @see Rao::Service::Configuration For notification settings configuration
      module Base::MailableConcern
        extend ActiveSupport::Concern

        # Sends an immediate email notification for this service result.
        #
        # This method creates and delivers an email notification containing
        # the service result details. The email is sent immediately using
        # ActionMailer's deliver_now method.
        #
        # @param recipient [String] Email address to send the notification to
        #                          (defaults to configured default recipient)
        # @return [Mail::Message] The delivered email message
        #
        # @example Send to default recipient
        #   result.notify_now
        #
        # @example Send to specific recipient
        #   result.notify_now("admin@example.com")
        #
        # @example Conditional notification
        #   result.notify_now if result.failed?
        def notify_now(recipient = nil)
          recipient ||= default_notification_recipient
          sender    ||= default_notification_sender
          ::Rao::Service::NotificationMailer.with(result: self, environment: notification_environment, sender: sender, recipient: recipient).result_email.deliver_now
        end

        # Returns the default sender email address for notifications.
        #
        # This method retrieves the configured default sender from the
        # Rao::Service::Configuration. Used when no specific sender is provided.
        #
        # @return [String] The default sender email address
        def default_notification_sender
          ::Rao::Service::Configuration.default_notification_sender
        end

        # Returns the default recipient email address for notifications.
        #
        # This method retrieves the configured default recipient from the
        # Rao::Service::Configuration. Used when no specific recipient is provided
        # to #notify_now.
        #
        # @return [String] The default recipient email address
        def default_notification_recipient
          ::Rao::Service::Configuration.default_notification_recipient
        end

        # Returns the notification environment configuration for this result.
        #
        # This method calls the configured notification environment proc
        # from Rao::Service::Configuration, passing the current result object
        # to determine environment-specific notification settings.
        #
        # @return [Object] The notification environment configuration
        def notification_environment
          ::Rao::Service::Configuration.notification_environment.call(self)
        end
      end
    end
  end
end
