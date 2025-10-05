module Rao
  module Service
    module Result
      # Provides JSON serialization functionality for service results.
      # 
      # This concern handles the conversion of service result objects to JSON format,
      # avoiding circular references and providing a clean, consistent structure.
      # It includes support for custom attributes defined by result classes and
      # provides hooks for subclasses to customize serialization behavior.
      #
      # @example Basic usage
      #   class MyServiceResult
      #     include Rao::Service::Result::Base::JsonSerializationConcern
      #     
      #     attr_accessor :data, :count
      #   end
      #
      #   result = MyServiceResult.new
      #   result.data = { name: "John" }
      #   result.count = 42
      #   result.as_json
      #   # => { messages: [], errors: [], data: { name: "John" }, count: 42 }
      #
      # @example Custom serialization
      #   class CustomResult
      #     include Rao::Service::Result::Base::JsonSerializationConcern
      #     
      #     def serialize_attribute(attr_name, value, options = {})
      #       case attr_name
      #       when :sensitive_data
      #         "[FILTERED]"
      #       else
      #         super
      #       end
      #     end
      #   end
      module Base::JsonSerializationConcern
        extend ActiveSupport::Concern

        # Serializes the service result to a JSON-compatible hash.
        #
        # This method creates a clean JSON representation of the result object,
        # including messages, errors, and any custom attributes defined by the
        # result class. It handles nested objects that support JSON serialization
        # and avoids circular references.
        #
        # @param options [Hash] Serialization options passed to nested objects
        # @return [Hash] JSON-compatible hash representation
        #
        # @example Basic serialization
        #   result.as_json
        #   # => { messages: ["Success"], errors: [], data: {...} }
        #
        # @example With serialization options
        #   result.as_json(only: [:name, :email])
        #   # => { messages: [], errors: [], data: { name: "John", email: "john@example.com" } }
        def as_json(options = {})
          # Start with basic result attributes
          result = {}

          # Add messages
          result[:messages] = @messages.map(&:to_s)

          # Add errors
          result[:errors] = @errors.full_messages

          # Add custom attributes defined by the result class
          self.class.attribute_names.each do |attr_name|
            value = send(attr_name)
            if value.respond_to?(:as_json)
              result[attr_name] = value.as_json(options)
            else
              result[attr_name] = value
            end
          end

          result
        end

        # Hook method for customizing attribute serialization.
        #
        # This method allows subclasses to override how specific attributes
        # are serialized to JSON. By default, it calls #as_json on objects that
        # support it, or returns the value as-is for primitive types.
        #
        # @param attr_name [Symbol] The name of the attribute being serialized
        # @param value [Object] The value to serialize
        # @param options [Hash] Serialization options
        # @return [Object] The serialized value
        #
        # @example Custom serialization for sensitive data
        #   def serialize_attribute(attr_name, value, options = {})
        #     case attr_name
        #     when :password, :secret_key
        #       "[FILTERED]"
        #     when :user
        #       value.as_json(only: [:id, :name])
        #     else
        #       super
        #     end
        #   end
        def serialize_attribute(attr_name, value, options = {})
          if value.respond_to?(:as_json)
            value.as_json(options)
          else
            value
          end
        end
      end
    end
  end
end
