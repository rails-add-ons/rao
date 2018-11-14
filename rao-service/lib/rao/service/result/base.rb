require 'rao/service'
require 'active_model/naming'
require 'active_model/translation'

module Rao
  module Service::Result
    class Base
      extend ActiveModel::Translation
      
      attr_reader :messages, :errors, :service

      def initialize(service)
        @service = service
      end

      def model_name
        @service.model_name
      end

      module Succeedable
        def success?
          !failed?
        end

        def failed?
          @errors.any?
        end

        def ok?
          success?
        end
      end

      include Succeedable

      module Mailable
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

      include Mailable if Rao::Service.rails_present?
    end
  end
end
