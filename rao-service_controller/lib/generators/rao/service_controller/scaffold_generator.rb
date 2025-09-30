module Rao
  module ServiceController
    module Generators
      class ScaffoldGenerator < Rails::Generators::NamedBase
        source_root File.expand_path("templates", __dir__)

        def create_service_file
          # call the service generator with the same arguments
          generate "rao:service:service", file_name, *args
        end
        
        def create_controller_file
          # call the controller generator with the same arguments
          generate "rao:service_controller:controller", file_name, *args
        end
        
        def create_feature_spec_file
          template "feature_spec.rb", File.join("spec/features", class_path, "#{file_name}_feature_spec.rb")
        end

        def create_routes
          route "resource :#{file_name.pluralize}, only: [:new, :create]"
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
          @base_path ||= "/#{class_path.join('/')}/#{file_name}".gsub(/\/+/, '/').pluralize
        end
        
        # Derives the params name for strong parameters
        # Example: "user_services" -> "user_service"
        def params_name
          @params_name ||= file_name.singularize
        end
        
        # Derives the controller class name
        # Example: "test_service" -> "TestServicesController"
        def controller_class
          @controller_class ||= "#{class_name}Controller"
        end
      end
    end
  end
end