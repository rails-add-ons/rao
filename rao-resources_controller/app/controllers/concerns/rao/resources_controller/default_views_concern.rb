# This module, `Rao::ResourcesController::DefaultViewsConcern`, is a concern that can be included in a Rails controller
# to override the default view path prefixes. It ensures that the view lookup path includes the default view path for
# Rao resources controllers.
#
# ### Why to use this:
# When you are using Rao::ResourcesController and you want your controllers to automatically include the default views,
# you can include this concern in your controller. This is particularly useful if you want to use the default views and
# start from there customizing and overriding the defaults.
#
# To use this concern, simply include it in your controller:
#
# ```ruby
# class MyController < ApplicationController
#   include Rao::ResourcesController::DefaultViewsConcern
# end
# ```
#
# By including this concern, the `_prefixes` method is overridden to append the `rao/resources_controller/base` path
# to the view lookup paths. This means that when Rails looks for views, it will also consider this path, allowing you
# to place your shared Rao views in the specified directory.
module Rao
  module ResourcesController
    module DefaultViewsConcern
      extend ActiveSupport::Concern

      private

      # Overrides the _prefixes method to include the default view path for Rao resources controllers.
      #
      # @return [Array<String>] an array of view path prefixes
      def _prefixes
        super + ['rao/resources_controller/base']
      end
    end
  end
end
