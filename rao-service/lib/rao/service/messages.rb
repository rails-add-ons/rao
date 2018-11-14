require "rao/service/message/base"

module Rao
  module Service
      module Messages
      private

      def initialize_messages
        @messages = []
      end

      def say(what, &block)
        @indent ||= 0
        if block_given?
          @indent += 1
          output(_message("#{output_prefix}#{("  " * @indent)}#{what}...", level: @indent))
          block_result = yield
          say_done
          @indent -= 1
          block_result
        else
          output(_message("#{output_prefix}#{("  " * @indent)}#{what}", level: @indent))
        end
      end

      def say_done
        say "  => Done"
      end

      def output_prefix
        "[#{self.class.name}] "
      end

      def output(what)
        @messages << what
        puts what unless silenced?
      end

      def silenced?
        !!@options[:silence]
      end

      def copy_messages_to_result
        @result.instance_variable_set(:@messages, @messages)
      end

      def _message(content, options = {})
        Rao::Service::Message::Base.new(content, level: options[:level])
      end
    end
  end
end