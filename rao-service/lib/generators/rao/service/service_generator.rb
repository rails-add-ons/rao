module Rao
  module Service
    module Generators
      # Rails generator for creating Rao::Service classes with attributes and validations.
      #
      # This generator creates a service class that inherits from Rao::Service::Base,
      # along with a corresponding RSpec test file. It supports defining attributes
      # with types and automatically generates appropriate validations and test data.
      #
      # == Usage
      #
      #   rails generate rao:service UserService name:string email:string age:integer
      #
      # This will create:
      # - app/services/user_service.rb
      # - spec/services/user_service_spec.rb
      #
      # == Generated Service Structure
      #
      # The generated service includes:
      # - A Result class for encapsulating service results
      # - Attribute accessors for all defined fields
      # - Presence validations for string fields
      # - A private _perform method for business logic
      # - A private save method for persistence
      #
      # == Field Types Supported
      #
      # * string - generates commented presence validation
      # * integer - generates commented presence validation
      # * boolean - generates commented presence validation
      # * decimal - generates commented presence validation
      # * float - generates commented presence validation
      # * date - generates commented presence validation
      # * datetime/timestamp - generates commented presence validation
      #
      # == Examples
      #
      # === Basic Service
      #   rails generate rao:service CreateUser name:string email:string
      #
      # Generates:
      #   class CreateUser < Rao::Service::Base
      #     class Result < Rao::Service::Result::Base
      #       attr_accessor :name
      #       attr_accessor :email
      #     end
      #
      #     attr_accessor :name
      #     attr_accessor :email
      #
      #     # validates :name, presence: true
      #     # validates :email, presence: true
      #
      #     private
      #
      #     def _perform
      #       # add business logic here
      #     end
      #
      #     def save
      #       # persist changes here
      #     end
      #   end
      #
      # === Namespaced Service
      #   rails generate rao:service Admin::UserService name:string role:string
      #
      # Creates: app/services/admin/user_service.rb
      #
      # === Service with Various Field Types
      #   rails generate rao:service ProcessOrder \
      #     order_id:integer \
      #     amount:decimal \
      #     processed_at:datetime \
      #     is_urgent:boolean
      #
      # Generates:
      #   class ProcessOrder < Rao::Service::Base
      #     class Result < Rao::Service::Result::Base
      #       attr_accessor :order_id
      #       attr_accessor :amount
      #       attr_accessor :processed_at
      #       attr_accessor :is_urgent
      #     end
      #
      #     attr_accessor :order_id
      #     attr_accessor :amount
      #     attr_accessor :processed_at
      #     attr_accessor :is_urgent
      #
      #     # validates :order_id, presence: true
      #     # validates :amount, presence: true
      #     # validates :processed_at, presence: true
      #     # validates :is_urgent, presence: true
      #
      # == Usage in Controllers
      #
      #   class UsersController < ApplicationController
      #     def create
      #       result = CreateUser.new(user_params).perform
      #
      #       if result.success?
      #         redirect_to user_path(result.user), notice: 'User created successfully'
      #       else
      #         render :new, alert: result.errors.full_messages.join(', ')
      #       end
      #     end
      #
      #     private
      #
      #     def user_params
      #       params.require(:user).permit(:name, :email)
      #     end
      #   end
      #
      # == Testing
      #
      # The generator creates comprehensive RSpec tests including:
      # - Service inheritance verification
      # - Result object testing
      # - Attribute assignment testing
      # - Error handling verification
      #
      # Run tests with:
      #   rspec spec/services/user_service_spec.rb
      #
      # == Customization
      #
      # After generation, you can customize the service by:
      # - Adding custom validations in the service class
      # - Implementing business logic in the _perform method
      # - Adding persistence logic in the save method
      # - Extending the Result class with additional attributes
      #
      # == Dependencies
      #
      # This generator requires:
      # - Rails application
      # - Rao::Service::Base class
      # - Rao::Service::Result::Base class
      # - RSpec (for generated tests)
      class ServiceGenerator < Rails::Generators::NamedBase
        source_root File.expand_path("templates", __dir__)
        
        def create_service_file
          template "service.rb", File.join("app/services", class_path, "#{file_name}.rb")
        end

        def create_service_spec_file
          template "service_spec.rb", File.join("spec/services", class_path, "#{file_name}_spec.rb")
        end

        private

        # Parses the field arguments passed to the generator
        # Example: ["name:string", "email:string", "age:integer"] -> [["name", "string"], ["email", "string"], ["age", "integer"]]
        def field_pairs
          @field_pairs ||= args.map { |arg| arg.split(':') }
        end

        # Returns the field names as an array
        # Example: ["name:string", "email:string", "age:integer"] -> ["name", "email", "age"]
        def field_names
          @field_names ||= field_pairs.map(&:first)
        end

        # Returns the field types as an array
        # Example: ["name:string", "email:string", "age:integer"] -> ["string", "string", "integer"]
        def field_types
          @field_types ||= field_pairs.map(&:last)
        end

        # Returns a hash of field names to types
        # Example: ["name:string", "email:string", "age:integer"] -> {"name" => "string", "email" => "string", "age" => "integer"}
        def fields_hash
          @fields_hash ||= Hash[field_pairs]
        end

        # Returns attr_accessor declarations for the service
        def attr_accessors
          return "" if field_names.empty?
          field_names.map { |name| "  attr_accessor :#{name}" }.join("\n")
        end

        # Returns attr_accessor declarations for the result class
        def result_attr_accessors
          return "" if field_names.empty?
          field_names.map { |name| "    attr_accessor :#{name}" }.join("\n")
        end

        # Returns validation declarations (commented out)
        def validations
          return "" if field_names.empty?
          # Add commented validation lines for all fields
          field_names.map { |name| "  # validates :#{name}, presence: true" }.join("\n")
        end

        # Returns test attributes for the spec
        def test_attributes
          return "{}" if field_names.empty?
          attributes = field_names.map do |name|
            case fields_hash[name]
            when 'string'
              "#{name}: 'test_#{name}'"
            when 'integer'
              "#{name}: 42"
            when 'boolean'
              "#{name}: true"
            when 'decimal'
              "#{name}: 10.5"
            when 'float'
              "#{name}: 10.5"
            when 'date'
              "#{name}: Date.current"
            when 'datetime', 'timestamp'
              "#{name}: Time.current"
            else
              "#{name}: 'test_#{name}'"
            end
          end
          "{ #{attributes.join(', ')} }"
        end
      end
    end
  end
end