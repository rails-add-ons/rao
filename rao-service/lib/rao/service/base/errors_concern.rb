require "rao/service/message/base"

module Rao
  module Service
    # Provides error handling and validation functionality for service objects.
    #
    # This concern adds the ability to collect, manage, and transfer errors during
    # service execution. It integrates with ActiveModel::Errors to provide a
    # consistent error handling interface that works well with Rails validation
    # patterns and form helpers.
    #
    # The concern provides:
    # - Error collection and validation state tracking
    # - Error transfer to service result objects
    # - Error copying from other objects (like ActiveRecord models)
    # - Combined error addition and logging functionality
    #
    # @example Basic error handling
    #   class CreateUserService < Rao::Service::Base
    #     attr_accessor :email, :name
    #
    #     private
    #
    #     def _perform
    #       if email.blank?
    #         add_error(:email, "Email is required")
    #       end
    #
    #       if name.blank?
    #         add_error_and_say(:name, "Name is required")
    #       end
    #
    #       return if errors.any?
    #
    #       @user = User.create!(email: email, name: name)
    #       result.user = @user
    #     end
    #   end
    #
    # @example Copying errors from ActiveRecord models
    #   class UpdateProfileService < Rao::Service::Base
    #     attr_accessor :user, :profile_data
    #
    #     private
    #
    #     def _perform
    #       @user.assign_attributes(profile_data)
    #       unless @user.save
    #         copy_errors_from_to(@user, :user)
    #         return
    #       end
    #
    #       result.user = @user
    #     end
    #   end
    module Base::ErrorsConcern
      extend ActiveSupport::Concern

      private

      # Initializes the ActiveModel::Errors object for the service instance.
      # Called during service initialization.
      def initialize_errors
        @errors = ActiveModel::Errors.new(self)
      end

      # Copies collected errors to the service result object.
      # Called during result preparation to make errors available externally.
      def copy_errors_to_result
        @result.instance_variable_set(:@errors, @errors)
      end

      # Copies errors from another object (like an ActiveRecord model) to this service.
      #
      # This method is useful for propagating validation errors from associated
      # models or other objects to the service's error collection.
      #
      # @param obj [Object] The object to copy errors from (must respond to #errors)
      # @param key_prefix [Symbol] The prefix to add to error keys
      #
      # @example
      #   user = User.new(email: "")
      #   user.valid? # => false
      #   copy_errors_from_to(user, :user)
      #   # Now @errors contains user.email errors under the :user key
      def copy_errors_from_to(obj, key_prefix)
        obj.errors.each do |key, message|
          @errors.add(key_prefix, message)
        end
      end

      # Adds an error and simultaneously outputs it as a message.
      #
      # This is a convenience method that combines error collection with message
      # logging, useful for providing immediate feedback during service execution.
      #
      # @param attribute [Symbol] The attribute the error relates to
      # @param message [String] The error message
      #
      # @example
      #   add_error_and_say(:email, "Email format is invalid")
      #   # Adds error to @errors AND outputs message via say()
      def add_error_and_say(attribute, message)
        add_error(attribute, message)
        say(message)
      end

      # Adds an error to the service's error collection.
      #
      # @param attribute [Symbol] The attribute the error relates to
      # @param message [String] The error message
      #
      # @example
      #   add_error(:email, "Email is required")
      #   add_error(:name, "Name must be at least 2 characters")
      def add_error(attribute, message)
        @errors.add(attribute, message)
      end
    end
  end
end