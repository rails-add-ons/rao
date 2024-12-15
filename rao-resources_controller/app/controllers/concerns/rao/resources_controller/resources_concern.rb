module Rao
  module ResourcesController
    # This module provides a concern for controllers to define and use a `resource_class` method.
    # It ensures that the `resource_class` method is implemented in the including controller and
    # provides a helper method for accessing it.
    #
    # Example:
    #   class MyController < ApplicationController
    #     include Rao::ResourcesController::ResourcesConcern
    #
    #     def self.resource_class
    #       MyResource
    #     end
    #   end
    #
    # The `resource_class` method must be implemented in the including controller.
    # If not implemented, an exception will be raised.
    #
    # Methods:
    # - resource_class: Class method that must be implemented in the including controller.
    # - resource_class: Instance method that returns the class defined by the class method.
    #
    # Helper Methods:
    # - resource_class: Makes the `resource_class` method available as a helper method in views.
    module ResourcesConcern
      extend ActiveSupport::Concern

      class_methods do
        def resource_class
          raise "Please implement the class method `resource_class` in your controller."
        end

        def plural?
          true
        end
  
        def singular?
          !plural?
        end
      end

      included do
        helper_method :resource_class, :plural?, :singular?
      end

      private

      def resource_class
        self.class.resource_class
      end

      def plural?
        self.class.plural?
      end

      def singular?
        self.class.singular?
      end
    end
  end
end
