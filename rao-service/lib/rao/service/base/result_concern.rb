require "rao/service/message/base"

module Rao
  module Service
    module Base::ResultConcern
      extend ActiveSupport::Concern

      private

      def initialize_result
        @result = result_class.new(self)
      end

      def perform_result
        @result
      end

      def result_class
        "#{self.class.name}::Result".constantize
      end
    end
  end
end
