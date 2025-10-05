require 'rao/service'
require 'active_model/naming'
require 'active_model/translation'

module Rao
  # Base class for service results that provides a standardized way to handle
  # and return results from service operations.
  #
  # This class serves as the foundation for all service result objects, providing
  # common functionality including message handling, error management, attribute
  # tracking, JSON serialization, and success/failure state management.
  #
  # The base class automatically includes several concerns that provide
  # specialized functionality:
  # - MailableConcern: Email notification capabilities (when Rails is present)
  # - AttributeNamesConcern: Dynamic attribute management
  # - SucceedableConcern: Success/failure state handling
  # - JsonSerializationConcern: JSON serialization with circular reference protection
  #
  # @example Basic usage
  #   class CreateUserResult < Rao::Service::Result::Base
  #     attr_accessor :user, :confirmation_sent
  #   end
  #
  #   result = CreateUserResult.new(service)
  #   result.add_message("User created successfully")
  #   result.user = created_user
  #   result.confirmation_sent = true
  #
  # @example With errors
  #   result = CreateUserResult.new(service)
  #   result.add_error("Email already exists")
  #   result.success? # => false
  #
  # @see Rao::Service::Result::Base::MailableConcern
  # @see Rao::Service::Result::Base::AttributeNamesConcern
  # @see Rao::Service::Result::Base::SucceedableConcern
  # @see Rao::Service::Result::Base::JsonSerializationConcern
  module Service::Result
    class Base
      extend ActiveModel::Translation

      if Rao::Service.rails_present?
        require 'rao/service/result/base/mailable_concern'
        include MailableConcern
      end

      require 'rao/service/result/base/attribute_names_concern'
      include AttributeNamesConcern

      require 'rao/service/result/base/succeedable_concern'
      include SucceedableConcern

      require 'rao/service/result/base/json_serialization_concern'
      include JsonSerializationConcern

      # @!attribute [r] messages
      #   @return [Array<String>] Array of success/informational messages
      # @!attribute [r] errors  
      #   @return [ActiveModel::Errors] ActiveModel errors object containing validation errors
      # @!attribute [r] service
      #   @return [Rao::Service::Base] The service instance that created this result
      attr_reader :messages, :errors, :service

      # Initializes a new service result instance.
      #
      # @param service [Rao::Service::Base] The service instance that created this result
      # @return [Rao::Service::Result::Base] A new result instance
      def initialize(service)
        @service = service
      end

      # Delegates model name to the underlying service.
      #
      # This allows the result to participate in ActiveModel naming conventions
      # and provides consistent model naming for forms and other Rails features.
      #
      # @return [ActiveModel::Name] The model name from the service
      def model_name
        @service.model_name
      end

      # Delegates model conversion to the underlying service.
      #
      # This allows the result to be treated as a model in Rails contexts,
      # enabling features like form helpers and routing.
      #
      # @return [Object] The model representation from the service
      def to_model
        @service.to_model
      end
    end
  end
end
