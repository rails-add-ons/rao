require 'active_support/concern'
require 'active_support/core_ext/hash/reverse_merge'
require "rao/service/result/base"
require 'active_model'

module Rao
  module Service
    # Base class for service objects that encapsulates business logic and operations.
    #
    # This class provides a standardized foundation for implementing service objects
    # in Ruby applications, following the Service Object pattern. It includes
    # comprehensive functionality for handling attributes, callbacks, messages,
    # errors, and results.
    #
    # The base class automatically includes several concerns that provide
    # specialized functionality:
    # - ActiveJobConcern: Background job processing capabilities (when ActiveJob is present)
    # - I18nConcern: Internationalization support for error messages and labels
    # - AutosaveConcern: Automatic saving of associated models
    # - CallbacksConcern: Before/after callback hooks for service execution
    # - MessagesConcern: Success and informational message handling
    # - ErrorsConcern: Error collection and validation
    # - ResultConcern: Service result object management
    #
    # @example Basic service implementation
    #   class CreateUserService < Rao::Service::Base
    #     attr_accessor :email, :name, :password
    #
    #     def perform
    #       user = User.new(email: email, name: name, password: password)
    #       if user.save
    #         add_message("User created successfully")
    #         result.user = user
    #       else
    #         add_errors(user.errors)
    #       end
    #       result
    #     end
    #   end
    #
    #   # Usage
    #   result = CreateUserService.call(email: "user@example.com", name: "John")
    #   if result.success?
    #     puts "User created: #{result.user.name}"
    #   else
    #     puts "Errors: #{result.errors.full_messages}"
    #   end
    #
    # @example With callbacks
    #   class ProcessOrderService < Rao::Service::Base
    #     before_perform :validate_inventory
    #     after_perform :send_confirmation_email
    #
    #     def perform
    #       # Order processing logic
    #     end
    #
    #     private
    #
    #     def validate_inventory
    #       # Inventory validation
    #     end
    #
    #     def send_confirmation_email
    #       # Send email
    #     end
    #   end
    #
    # @see Rao::Service::Base::ActiveJobConcern
    # @see Rao::Service::Base::I18nConcern
    # @see Rao::Service::Base::AutosaveConcern
    # @see Rao::Service::Base::CallbacksConcern
    # @see Rao::Service::Base::MessagesConcern
    # @see Rao::Service::Base::ErrorsConcern
    # @see Rao::Service::Base::ResultConcern
    class Base
      if Rao::Service.active_job_present?
        require 'rao/service/base/active_job_concern'
        include ActiveJobConcern
      end

      require 'rao/service/base/i18n_concern'
      include I18nConcern

      require 'rao/service/base/autosave_concern'
      include AutosaveConcern

      require 'rao/service/base/callbacks_concern'
      include CallbacksConcern

      require 'rao/service/base/messages_concern'
      include MessagesConcern

      require 'rao/service/base/errors_concern'
      include ErrorsConcern

      require 'rao/service/base/result_concern'
      include ResultConcern

      include ActiveModel::Model
      extend ActiveModel::Naming

      # Enhanced attr_accessor that also tracks attribute names for serialization.
      #
      # This method extends the standard attr_accessor to automatically register
      # attribute names, enabling dynamic attribute introspection and serialization.
      #
      # @param args [Array<Symbol>] Attribute names to create accessors for
      # @return [void]
      #
      # @example
      #   class MyService < Rao::Service::Base
      #     attr_accessor :name, :email, :age
      #   end
      #   MyService.attribute_names # => [:name, :email, :age]
      def self.attr_accessor(*args)
        super
        add_attribute_names(*args)
      end

      # Enhanced attr_reader that also tracks attribute names for serialization.
      #
      # This method extends the standard attr_reader to automatically register
      # attribute names, enabling dynamic attribute introspection and serialization.
      #
      # @param args [Array<Symbol>] Attribute names to create readers for
      # @return [void]
      #
      # @example
      #   class MyService < Rao::Service::Base
      #     attr_reader :id, :created_at
      #   end
      #   MyService.attribute_names # => [:id, :created_at]
      def self.attr_reader(*args)
        super
        add_attribute_names(*args)
      end

      # Adds attribute names to the class's attribute registry.
      #
      # This method is used internally to track which attributes are defined
      # on the service class, enabling dynamic introspection and serialization.
      #
      # @param args [Array<Symbol>] Attribute names to register
      # @return [void]
      def self.add_attribute_names(*args)
        args.each do |attr_name|
          attribute_names << attr_name
        end
      end

      # Returns the list of registered attribute names for this service class.
      #
      # This method provides access to all attribute names that have been
      # registered through attr_accessor, attr_reader, or add_attribute_names.
      # Used for dynamic attribute introspection and serialization.
      #
      # @return [Array<Symbol>] Array of registered attribute names
      def self.attribute_names
        (@attr_names ||= [])
      end

      # Convenience class method to instantiate and perform a service in one call.
      #
      # This method provides a clean interface for calling services without
      # explicitly instantiating them. It creates a new instance with the
      # provided arguments and immediately calls the #perform method.
      #
      # @param args [Array] Arguments to pass to the service constructor
      # @return [Rao::Service::Result::Base] The result of the service execution
      #
      # @example
      #   result = CreateUserService.call(email: "user@example.com", name: "John")
      #   if result.success?
      #     puts "User created successfully"
      #   end
      def self.call(*args)
        new(*args).perform
      end

      # Initializes a new service instance with attributes and options.
      #
      # This method sets up the service instance with the provided attributes,
      # initializes internal state (result, errors, messages), and calls the
      # after_initialize callback hook.
      #
      # @param attributes [Hash] Attributes to set on the service instance
      # @param options [Hash] Additional options for service configuration
      # @param block [Proc] Optional block to be stored for later execution
      # @return [void]
      def initialize(attributes = {}, options = {}, &block)
        @options    = options
        @block      = block
        @attributes = {}
        set_attributes(attributes)
        initialize_result
        initialize_errors
        initialize_messages
        after_initialize
      end

      private

      # Private module providing attribute management functionality.
      #
      # This module contains methods for setting attributes from a hash
      # and retrieving all attributes as a hash. It's included privately
      # to provide attribute handling capabilities without exposing these
      # methods as part of the public API.
      module Attributes
        # Sets attributes on the service instance from a hash.
        #
        # This method iterates through the provided attributes hash and
        # calls the appropriate setter method for each attribute.
        #
        # @param attributes [Hash] Hash of attribute names to values
        # @return [void]
        def set_attributes(attributes)
          attributes.each do |key, value|
            send("#{key}=", value)
          end
        end

        # Returns a hash of all registered attributes and their current values.
        #
        # This method creates a hash containing all attributes that have been
        # registered through attr_accessor, attr_reader, or add_attribute_names,
        # along with their current values.
        #
        # @return [Hash] Hash of attribute names to their current values
        def attributes
          self.class.attribute_names.each_with_object({}) do |attr, m|
            m[attr] = send(attr)
          end
        end
      end

      include Attributes
    end
  end
end
