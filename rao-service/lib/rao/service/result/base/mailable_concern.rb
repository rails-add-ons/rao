module Rao
  module Service
    module Result
      module Base::MailableConcern
        extend ActiveSupport::Concern

        def notify_now(recipient = nil)
          recipient ||= default_notification_recipient
          sender    ||= default_notification_sender
          ::Rao::Service::NotificationMailer.with(result: self, environment: notification_environment, sender: sender, recipient: recipient).result_email.deliver_now
        end

        def default_notification_sender
          ::Rao::Service::Configuration.default_notification_sender
        end

        def default_notification_recipient
          ::Rao::Service::Configuration.default_notification_recipient
        end

        def notification_environment
          ::Rao::Service::Configuration.notification_environment.call(self)
        end
      end
    end
  end
end
