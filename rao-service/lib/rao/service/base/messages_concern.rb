require "rao/service/message/base"

module Rao
  module Service
    # Provides message handling and logging functionality for service objects.
    #
    # This concern adds the ability to generate structured messages during service
    # execution, with support for indentation, prefixes, and output control.
    # Messages are automatically collected and can be transferred to the service
    # result for external access.
    #
    # The concern provides:
    # - Structured message output with indentation
    # - Automatic prefixing with service class name
    # - Block-based message grouping with start/end indicators
    # - Silence mode to suppress console output
    # - Message collection for result objects
    #
    # @example Basic message usage
    #   class CreateUserService < Rao::Service::Base
    #     private
    #
    #     def _perform
    #       say "Starting user creation process"
    #       say "Validating user data" do
    #         # Validation logic
    #         say "Email format valid"
    #         say "Name provided"
    #       end
    #       say "User created successfully"
    #     end
    #   end
    #
    #   # Output:
    #   # CreateUserService Starting user creation process
    #   # CreateUserService Validating user data...
    #   #   CreateUserService Email format valid
    #   #   CreateUserService Name provided
    #   # CreateUserService => Done
    #   # CreateUserService User created successfully
    #
    # @example With silence mode
    #   service = CreateUserService.new({}, silence: true)
    #   service.perform  # No console output, but messages still collected
    module Base::MessagesConcern
      extend ActiveSupport::Concern

      private

      # Initializes the messages array for the service instance.
      # Called during service initialization.
      def initialize_messages
        @messages = []
      end

      # Outputs a message with optional block-based grouping and indentation.
      #
      # When called without a block, outputs a simple message. When called with
      # a block, creates a grouped message with start/end indicators and
      # indents all messages within the block.
      #
      # @param what [String] The message content to output
      # @yield Optional block to execute with indented message context
      # @return [Object] The result of the block (if provided), otherwise nil
      #
      # @example Simple message
      #   say "Processing complete"
      #
      # @example Grouped messages
      #   say "Processing data" do
      #     say "Validating input"
      #     say "Transforming data"
      #   end
      #   # Output:
      #   # ServiceClass Processing data...
      #   #   ServiceClass Validating input
      #   #   ServiceClass Transforming data
      #   # ServiceClass => Done
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

      # Outputs a "Done" completion message.
      # Used internally to mark the end of grouped message blocks.
      def say_done
        say "=> Done"
      end

      # Returns the prefix to use for messages (service class name).
      #
      # @return [String] The service class name
      def prefix
        self.class.name
      end

      # Adds a message to the collection and optionally outputs to console.
      #
      # @param what [String] The message to add and output
      # @return [void]
      def output(what)
        @messages << what
        puts what unless silenced?
      end

      # Checks if the service is in silence mode.
      #
      # @return [Boolean] True if silenced, false otherwise
      def silenced?
        !!@options[:silence]
      end

      # Copies collected messages to the service result object.
      # Called during result preparation to make messages available externally.
      def copy_messages_to_result
        @result.instance_variable_set(:@messages, @messages)
      end

      # Creates a formatted message object with the specified options.
      #
      # @param content [String] The message content
      # @param options [Hash] Formatting options
      # @option options [Integer] :indent_level The indentation level
      # @option options [String] :prefix The message prefix
      # @option options [String] :suffix The message suffix
      # @return [Rao::Service::Message::Base] The formatted message object
      def _message(content, options = {})
        Rao::Service::Message::Base.new(content, indent_level: options[:indent_level], prefix: options[:prefix], suffix: options[:suffix])
      end
    end
  end
end