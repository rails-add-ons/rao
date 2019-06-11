module Rao
  module Api
    module ServiceController::ServiceConcern
      extend ActiveSupport::Concern

      def service_class
        unless self.class.respond_to?(:service_class)
          raise "undefined method `service_class' for #{self.class.name}: Add a service_class method to your controller. Example: def self.service_class; MyAmazingService; end"
        end
        self.class.service_class
      end
    end
  end
end