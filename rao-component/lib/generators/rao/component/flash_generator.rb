module Rao
  module Component
    module Generators
      class FlashGenerator < Rails::Generators::Base
        source_root File.expand_path("templates", __dir__)
        def add_helper_to_application_controller
          insert_into_file "app/controllers/application_controller.rb", after: "class ApplicationController < ActionController::Base\n" do
            "  helper Rao::Component::FlashHelper\n"
          end
        end

        def add_partial
          template "_flash.html.erb", "app/views/shared/_flash.html.erb"
        end
        
        def add_flash_to_application_layout
          insert_into_file "app/views/layouts/application.html.erb", before: "<%= yield %>\n" do
            "  <%= render \"shared/flash\" %>\n"
          end
        end
      end
    end
  end
end