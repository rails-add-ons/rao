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

      require 'rao/service/result/base/attribute_names_concern'
      include AttributeNamesConcern

      require 'rao/service/result/base/succeedable_concern'
      include SucceedableConcern

      attr_reader :service

      def initialize(service)
        @service = service
      end

      def errors
        @service.instance_variable_get(:@errors)
      end

      def model_name
        @service.model_name
      end

      def messages
        @service.instance_variable_get(:@messages)
      end
    end
  end
end
