module Rao
  module ResourcesController
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Generates the initializer"

        source_root File.expand_path("../templates", __FILE__)

        def generate_initializer
          template "initializer.rb", "config/initializers/rao-resources_controller.rb"
        end

        def generate_view_helper
          inject_into_file "app/controllers/application_controller.rb", "view_helper Rao::ResourcesController::ResourceViewHelper, as: :resource_helper\n", after: "class ApplicationController < ActionController::Base\n"
        end
      end
    end
  end
end
