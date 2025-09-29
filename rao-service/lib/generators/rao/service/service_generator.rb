module Rao
  module Service
    module Generators
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

        # Returns validation declarations
        def validations
          return "" if field_names.empty?
          # Add basic presence validations for string fields
          string_fields = field_pairs.select { |name, type| type == 'string' }.map(&:first)
          return "" if string_fields.empty?
          string_fields.map { |name| "  validates :#{name}, presence: true" }.join("\n")
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
            when 'text'
              "#{name}: 'test #{name} content'"
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