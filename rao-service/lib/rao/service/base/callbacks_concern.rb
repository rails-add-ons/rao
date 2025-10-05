module Rao
  module Service
    # Provides callback functionality for service objects to hook into the execution lifecycle.
    #
    # This concern defines the standard callback methods that services can override to
    # customize their behavior at different stages of execution. It also implements
    # the main #perform method that orchestrates the callback execution flow.
    #
    # The callback flow follows this sequence:
    # 1. after_initialize (called during object initialization)
    # 2. before_validation (if validation is enabled)
    # 3. validation check (if validation fails, execution stops)
    # 4. after_validation (if validation passes)
    # 5. before_perform
    # 6. around_perform (wraps the main service logic)
    # 7. _perform (the actual service implementation)
    # 8. after_perform
    # 9. autosave (if enabled and no errors)
    # 10. perform_result (returns the final result)
    #
    # @example Basic callback usage
    #   class CreateUserService < Rao::Service::Base
    #     attr_accessor :email, :name
    #
    #     def before_perform
    #       say "Validating user data..."
    #     end
    #
    #     def after_perform
    #       say "User creation completed"
    #     end
    #
    #     private
    #
    #     def _perform
    #       # Actual user creation logic
    #       @user = User.create!(email: email, name: name)
    #       result.user = @user
    #     end
    #   end
    #
    # @example With validation callbacks
    #   class ProcessOrderService < Rao::Service::Base
    #     def before_validation
    #       say "Preparing validation..."
    #     end
    #
    #     def after_validation
    #       say "Validation passed, proceeding..."
    #     end
    #
    #     def around_perform
    #       say "Starting order processing..."
    #       yield
    #       say "Order processing completed"
    #     end
    #   end
    module Base::CallbacksConcern
      extend ActiveSupport::Concern

      # Hook called after service initialization is complete.
      # Override this method to perform setup tasks after the service is initialized.
      def after_initialize; end

      # Hook called before the main service logic executes.
      # Override this method to perform pre-execution setup or validation.
      def before_perform; end

      # Hook called after the main service logic completes successfully.
      # Override this method to perform cleanup or post-execution tasks.
      def after_perform; end

      # Hook called before validation runs (if validation is enabled).
      # Override this method to prepare data or set up validation context.
      def before_validation; end

      # Hook called after validation passes successfully.
      # Override this method to perform tasks that depend on validation success.
      def after_validation; end

      # Hook that wraps the main service execution with custom logic.
      # Override this method to add logging, error handling, or other wrapper functionality.
      # Must call `yield` to execute the main service logic.
      #
      # @yield Executes the main service logic (_perform method)
      def around_perform
        yield
      end

      # Main service execution method that orchestrates the callback flow.
      #
      # This method coordinates the entire service execution lifecycle, including
      # validation, callbacks, and autosave functionality. It follows this sequence:
      # 1. Run validation (if enabled) with before/after hooks
      # 2. Execute before_perform callback
      # 3. Run around_perform wrapper with _perform logic inside
      # 4. Execute after_perform callback
      # 5. Perform autosave (if enabled and no errors)
      # 6. Return the final result
      #
      # @param options [Hash] Execution options
      # @option options [Boolean] :validate Whether to run validation (default: true)
      # @return [Rao::Service::Result::Base] The service execution result
      #
      # @example Skip validation
      #   service.perform(validate: false)
      #
      # @example With default validation
      #   result = service.perform
      def perform(options = {})
        options.reverse_merge!(validate: true)
        validate = options.delete(:validate)
        if validate
          before_validation
          return perform_result unless valid?
          after_validation
        end
        before_perform
        around_perform do
          say "Performing" do
            _perform
          end
        end
        after_perform
        save if @errors.empty? && autosave? && respond_to?(:save, true)
        perform_result
      end
    end
  end
end
