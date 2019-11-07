require "rao/service/message/base"

module Rao
  module Service
    module Base::ErrorsConcern
      extend ActiveSupport::Concern

      private

      def initialize_errors
        @errors = ActiveModel::Errors.new(self)
      end

      def copy_errors_to_result
        @result.instance_variable_set(:@errors, @errors)
      end

      def copy_errors_from_to(obj, key_prefix)
        obj.errors.each do |key, message|
          @errors.add(key_prefix, message)
        end
      end

      def add_error_and_say(attribute, message)
        add_error(attribute, message)
        say(message)
      end

      def add_error(attribute, message)
        @errors.add(attribute, message)
      end
    end
  end
end