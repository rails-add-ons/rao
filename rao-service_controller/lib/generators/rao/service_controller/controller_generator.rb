module Rao
  module ServiceController
    module Generators
      class ControllerGenerator < Rails::Generators::NamedBase
        source_root File.expand_path("templates", __dir__)
        
        def create_controller_file
          template "controller.rb", File.join("app/controllers", class_path, "#{file_name.pluralize}_controller.rb")
        end

        def create_form_fields_file
          template "_form_fields.html.erb", File.join("app/views", class_path, "#{file_name.pluralize}", "_form_fields.html.erb")
        end

        private

        # Derives the service class name from the controller name
        # Example: "user_services" -> "UserService"
        def service_class
          @service_class ||= class_name
        end
        
        # Derives the route resource name (pluralized, underscored)
        # Example: "UserService" -> "user_services"
        def route_resource_name
          @route_resource_name ||= file_name
        end
        
        # Derives the base path for feature specs
        # Example: ["admin", "api"], "user_services" -> "/admin/api/user_services"
        def base_path
          @base_path ||= "/#{class_path.join('/')}/#{file_name}".gsub(/\/+/, '/')
        end
        
        # Derives the params name for strong parameters
        # Example: "user_services" -> "user_service"
        def params_name
          @params_name ||= file_name.singularize
        end
        
        # Derives the controller class name
        # Example: "test_service" -> "TestServicesController"
        def controller_class
          @controller_class ||= "#{class_name.pluralize}Controller"
        end

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

        # Returns the permitted parameters string for the controller
        def permitted_params
          return "" if field_names.empty?
          field_names.map { |name| ":#{name}" }.join(", ")
        end

        # Returns the form field inputs for the view template
        def form_inputs
          return "" if field_names.empty?
          field_names.map { |name| "  <%= form.input :#{name} %>" }.join("\n")
        end
      end
    end
  end
end