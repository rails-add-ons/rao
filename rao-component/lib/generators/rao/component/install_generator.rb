module Rao
  module Component
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc 'Generates the initializer'

        source_root File.expand_path('../templates', __FILE__)

        def generate_initializer
          template 'initializer.rb', 'config/initializers/rao-component.rb'
        end

        # Add Rao::Component::ApplicationHelper to ApplicationController
        def generate_application_controller_inserts
          insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do
            "  helper Rao::Component::ApplicationHelper\n  helper Rao::Component::FlashHelper\n"
          end
        end

        # Add importmap pin
        def add_importmap_pin
          append_to_file "config/importmap.rb", "pin \"rao-component\", to: \"rao-component/application.js\"\n"
        end

        # Add rao-component import to application.js
        def add_import_to_application_js
          append_to_file "app/javascript/application.js", "import \"rao-component\"\n"
        end
      end
    end
  end
end
