require 'rao/service'
require 'active_model/naming'
require 'active_model/translation'

module Rao
  module Service::Result
    class Base
      extend ActiveModel::Translation

      if Rao::Service.rails_present?
        require 'rao/service/result/base/mailable_concern'
        include MailableConcern
      end

      require 'rao/service/result/base/succeedable_concern'
      include SucceedableConcern

      attr_reader :messages, :errors, :service

      def initialize(service)
        @service = service
      end

      def model_name
        @service.model_name
      end
    end
  end
end
