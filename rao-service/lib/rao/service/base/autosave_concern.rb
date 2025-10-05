module Rao
  module Service
    # Provides autosave functionality for service objects to automatically save associated models.
    #
    # This concern adds the ability to automatically save associated models after
    # successful service execution. When autosave is enabled, any models that were
    # modified during service execution will be automatically saved if the service
    # completes without errors.
    #
    # Autosave can be enabled in several ways:
    # - Using the #call! class method (convenience method)
    # - Setting autosave option during initialization
    # - Calling #autosave! on a service instance
    # - Setting the autosave attribute directly
    #
    # @example Using call! class method
    #   class CreateUserService < Rao::Service::Base
    #     attr_accessor :user_data
    #
    #     private
    #
    #     def _perform
    #       @user = User.new(user_data)
    #       @profile = @user.build_profile(additional_data)
    #       result.user = @user
    #       result.profile = @profile
    #     end
    #   end
    #
    #   # Automatically saves @user and @profile after successful execution
    #   result = CreateUserService.call!(user_data: { name: "John" })
    #
    # @example Manual autosave control
    #   service = CreateUserService.new(user_data: { name: "John" })
    #   service.autosave = true
    #   result = service.perform
    #
    # @example Enable autosave on existing instance
    #   service = CreateUserService.new(user_data: { name: "John" })
    #   service.autosave!
    #   result = service.perform
    module Base::AutosaveConcern
      extend ActiveSupport::Concern

      if respond_to?(:class_methods)
        class_methods do
          # Convenience class method that creates a service instance with autosave enabled and executes it.
          #
          # This method combines instantiation, autosave activation, and execution in one call,
          # providing a clean interface for services that should automatically save their results.
          #
          # @param args [Array] Arguments to pass to the service constructor
          # @return [Rao::Service::Result::Base] The result of the service execution
          #
          # @example
          #   result = CreateUserService.call!(user_data: { name: "John" })
          #   # Equivalent to:
          #   # CreateUserService.new(user_data: { name: "John" }).autosave!.perform
          def call!(*args)
            new(*args).autosave!.perform
          end
        end
      else
        module ClassMethods
          # Legacy compatibility method for older ActiveSupport versions.
          # @see #call! for documentation
          def call!(*args)
            new(*args).perform!
          end
        end
      end

      # Checks if autosave is enabled for this service instance.
      #
      # @return [Boolean] True if autosave is enabled, false otherwise
      def autosave?
        !!@options[:autosave]
      end

      # Enables autosave for this service instance and returns self for method chaining.
      #
      # @return [self] Returns self to allow method chaining
      #
      # @example
      #   service.autosave!.perform
      def autosave!
        @options[:autosave] = true
        self
      end

      # Sets the autosave option for this service instance.
      #
      # @param value [Object] The value to set for autosave (will be cast to boolean)
      # @return [Boolean] The cast boolean value
      #
      # @example
      #   service.autosave = true
      #   service.autosave = "yes"  # Will be cast to true
      #   service.autosave = nil    # Will be cast to false
      def autosave=(value)
        @options[:autosave] = ActiveModel::Type::Boolean.new.cast(value)
      end

      # Enables autosave and then performs the service.
      #
      # This method is a convenience wrapper that combines autosave activation
      # with service execution in one call.
      #
      # @return [Rao::Service::Result::Base] The result of the service execution
      #
      # @example
      #   result = service.perform!
      #   # Equivalent to:
      #   # service.autosave!
      #   # service.perform
      def perform!
        autosave!
        perform
      end
    end
  end
end
