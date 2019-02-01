module Rao
  module Service
    class Job < ApplicationJob
      def perform(service_class_name, attributes = {}, options = {})
        service_class_name.constantize.call(attributes, options)
      end
    end
  end
end