module Rao
  module Service
    module Result
      # Provides success/failure state management for service result objects.
      #
      # This concern adds the ability to determine whether a service execution
      # was successful or failed based on the presence of errors. It provides
      # a simple and consistent interface for checking service execution status.
      #
      # The concern provides:
      # - Success state determination via #success? and #ok?
      # - Failure state determination via #failed?
      # - Error-based status evaluation (no errors = success)
      #
      # @example Basic usage
      #   result = CreateUserService.call(email: "user@example.com")
      #   
      #   if result.success?
      #     puts "User created successfully!"
      #     puts "User ID: #{result.user.id}"
      #   else
      #     puts "Failed to create user:"
      #     puts result.errors.full_messages.join(", ")
      #   end
      #
      # @example Using alias methods
      #   result = ProcessOrderService.call(order_data: {...})
      #   
      #   if result.ok?  # Same as result.success?
      #     redirect_to success_path
      #   else
      #     redirect_to error_path
      #   end
      #
      # @example Conditional logic
      #   result = SendEmailService.call(recipient: "user@example.com")
      #   
      #   if result.success?
      #     flash[:notice] = "Email sent successfully"
      #   else
      #     flash[:alert] = "Failed to send email"
      #   end
      module Base::SucceedableConcern
        extend ActiveSupport::Concern

        # Determines if the service execution was successful.
        #
        # A service execution is considered successful when there are no errors.
        # This method provides a simple boolean check for service success status.
        #
        # @return [Boolean] True if the service executed successfully (no errors), false otherwise
        #
        # @example
        #   result = CreateUserService.call(email: "user@example.com")
        #   result.success? # => true (if no errors occurred)
        #
        # @example
        #   result = CreateUserService.call(email: "invalid-email")
        #   result.success? # => false (if validation errors occurred)
        def success?
          !failed?
        end

        # Alias for #success? providing an alternative method name.
        #
        # @return [Boolean] True if the service executed successfully, false otherwise
        #
        # @example
        #   result = ProcessOrderService.call(order_data: {...})
        #   result.ok? # Same as result.success?
        alias_method :ok?, :success?

        # Determines if the service execution failed.
        #
        # A service execution is considered failed when there are any errors present.
        # This method provides a simple boolean check for service failure status.
        #
        # @return [Boolean] True if the service execution failed (has errors), false otherwise
        #
        # @example
        #   result = CreateUserService.call(email: "invalid-email")
        #   result.failed? # => true (if validation errors occurred)
        #
        # @example
        #   result = CreateUserService.call(email: "user@example.com")
        #   result.failed? # => false (if no errors occurred)
        def failed?
          @errors.any?
        end
      end
    end
  end
end
