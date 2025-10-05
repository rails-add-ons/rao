require "rao/service/message/base"

module Rao
  module Service
    # Provides result object management for service objects.
    #
    # This concern handles the creation and management of service result objects,
    # which encapsulate the outcome of service execution including success/failure
    # state, messages, errors, and any custom data returned by the service.
    #
    # The concern automatically:
    # - Creates the appropriate result class for each service
    # - Transfers messages and errors to the result object
    # - Provides the result object for external access
    #
    # Result classes are expected to follow the naming convention:
    # `{ServiceClass}::Result` (e.g., `CreateUserService::Result`)
    #
    # @example Basic result usage
    #   class CreateUserService < Rao::Service::Base
    #     attr_accessor :email, :name
    #
    #     private
    #
    #     def _perform
    #       @user = User.create!(email: email, name: name)
    #       result.user = @user
    #       result.success = true
    #     end
    #   end
    #
    #   class CreateUserService::Result < Rao::Service::Result::Base
    #     attr_accessor :user, :success
    #   end
    #
    #   # Usage
    #   result = CreateUserService.call(email: "user@example.com", name: "John")
    #   if result.success?
    #     puts "Created user: #{result.user.name}"
    #   else
    #     puts "Errors: #{result.errors.full_messages}"
    #   end
    #
    # @example Custom result class
    #   class ProcessDataService < Rao::Service::Base
    #     # Service implementation
    #   end
    #
    #   class ProcessDataService::Result < Rao::Service::Result::Base
    #     attr_accessor :processed_count, :processing_time, :data_summary
    #   end
    module Base::ResultConcern
      extend ActiveSupport::Concern

      private

      # Initializes the result object for the service instance.
      #
      # Creates a new instance of the service's result class, passing the service
      # instance as a parameter. The result class is determined by the naming
      # convention `{ServiceClass}::Result`.
      def initialize_result
        @result = result_class.new(self)
      end

      # Prepares and returns the final result object.
      #
      # This method is called at the end of service execution to prepare the
      # result object for external use. It copies all messages and errors
      # from the service to the result object.
      #
      # @return [Rao::Service::Result::Base] The prepared result object
      def perform_result
        copy_messages_to_result
        copy_errors_to_result
        @result
      end

      # Determines the result class for this service.
      #
      # Uses the naming convention `{ServiceClass}::Result` to find the
      # appropriate result class. If no custom result class is defined,
      # it will fall back to the base result class.
      #
      # @return [Class] The result class to use for this service
      #
      # @example
      #   # For CreateUserService, returns CreateUserService::Result
      #   # For ProcessDataService, returns ProcessDataService::Result
      def result_class
        "#{self.class.name}::Result".constantize
      end
    end
  end
end
