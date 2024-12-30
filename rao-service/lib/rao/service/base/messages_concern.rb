require "rao/service/message/base"

module Rao
  module Service
    module Base::MessagesConcern
      extend ActiveSupport::Concern

      private

      def initialize_messages
        @messages = []
      end

      def say(what, &block)
        @indent_level ||= 0
        if block_given?
          output(_message(what, indent_level: @indent_level, prefix: prefix, suffix: "..."))
          @indent_level += 1
          block_result = yield
          @indent_level -= 1
          say_done
          block_result
        else
          output(_message(what, indent_level: @indent_level, prefix: prefix))
        end
      end

      def say_done
        say "=> Done"
      end

      def prefix
        self.class.name
      end

      def output(what)
        @messages << what
        puts what unless silenced?
      end

      def silenced?
        !!@options[:silence]
      end

      def _message(content, options = {})
        Rao::Service::Message::Base.new(content, indent_level: options[:indent_level], prefix: options[:prefix], suffix: options[:suffix])
      end
    end
  end
end