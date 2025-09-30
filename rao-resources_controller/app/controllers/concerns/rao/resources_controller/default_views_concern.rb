# Provides default view templates for resource controllers with automatic view path resolution.
#
# This concern extends the Rails view lookup mechanism to include default Rao resource controller
# templates, allowing you to start with pre-built views and customize them as needed.
# It's particularly useful for rapid prototyping and consistent UI patterns across controllers.
#
# @example Basic usage with default templates
#   class PostsController < ApplicationController
#     include Rao::ResourcesController::DefaultViewsConcern
#     include Rao::ResourcesController::Plural::RestActionsConcern
#
#     def self.resource_class
#       Post
#     end
#   end
#
#   # Result: Automatic default view resolution
#   # - Rails automatically finds views in app/views/rao/resources_controller/base/
#   # - Provides consistent UI patterns across all resource controllers
#   # - Reduces boilerplate view code significantly
#   # - Allows gradual customization by overriding specific templates
#
# @example Custom view hierarchy
#   class PostsController < ApplicationController
#     include Rao::ResourcesController::DefaultViewsConcern
#   end
#
#   # View lookup order:
#   # 1. app/views/posts/ (your custom views)
#   # 2. app/views/rao/resources_controller/base/ (default templates)
#   # 3. app/views/application/ (fallback)
#
#   # Result: Flexible view customization
#   # - Override only the templates you need to customize
#   # - Inherit default styling and behavior for others
#   # - Maintain consistent look and feel across admin interfaces
#   # - Speed up development with pre-built components
#
# @example Gradual customization workflow
#   # 1. Start with default views (no custom templates needed)
#   # 2. Copy specific templates to app/views/posts/ when needed
#   # 3. Customize only the parts that differ from defaults
#   # 4. Maintain consistency with other resource controllers
#
#   # Result: Efficient development workflow
#   # - Rapid prototyping with minimal code
#   # - Consistent UI patterns across the application
#   # - Easy maintenance and updates
#   # - Professional appearance out of the box
module Rao
  module ResourcesController
    module DefaultViewsConcern
      extend ActiveSupport::Concern

      private

      # Overrides the _prefixes method to include the default view path for Rao resources controllers.
      #
      # @return [Array<String>] an array of view path prefixes
      def _prefixes
        super + ["rao/resources_controller/base"]
      end
    end
  end
end
