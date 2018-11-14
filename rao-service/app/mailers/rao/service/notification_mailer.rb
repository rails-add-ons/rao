module Rao
  module Service
    class NotificationMailer < ApplicationMailer
      def result_email
        @result      = params[:result]
        @sender      = params[:sender]
        @recipient   = params[:recipient]
        @environment = params[:environment]

        subject = "[#{@environment}][#{@result.service.class.name}] #{@result.ok? ? 'SUCCEEDED' : 'FAILED'}"

        mail(from: @sender, to: @recipient, subject: subject)
      end
    end
  end
end