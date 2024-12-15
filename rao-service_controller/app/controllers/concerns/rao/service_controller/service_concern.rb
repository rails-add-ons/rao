module Rao
  module ServiceController
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
    module ServiceConcern
      extend ActiveSupport::Concern

      class_methods do
        def service_class
          raise "Please implement the class method `service_class` in your controller."
        end

        def result_class
          "#{service_class}::Result".constantize
        end
      end

      included do
        helper_method :service_class, :result_class
      end

      private

      def service_class
        self.class.service_class
      end

      def result_class
        self.class.result_class
      end
    end
  end
end
