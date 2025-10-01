module Rao
  module ServiceController
    # This module provides a concern for controllers to define and use service classes.
    # It ensures that the `service_class` method is implemented in the including controller and
    # provides helper methods for accessing the service class and its result class.
    #
    # Example:
    #   class MyController < ApplicationController
    #     include Rao::ServiceController::ServiceConcern
    #
    #     def self.service_class
    #       MyService
    #     end
    #   end
    #
    # The `service_class` method must be implemented in the including controller.
    # If not implemented, an exception will be raised.
    #
    # Methods:
    # - service_class: Class method that must be implemented in the including controller.
    # - result_class: Class method that returns the result class (service_class::Result).
    # - service_class: Instance method that returns the class defined by the class method.
    # - result_class: Instance method that returns the result class.
    #
    # Helper Methods:
    # - service_class: Makes the `service_class` method available as a helper method in views.
    # - result_class: Makes the `result_class` method available as a helper method in views.
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
