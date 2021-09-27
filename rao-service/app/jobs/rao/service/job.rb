module Rao
  module Service
    class Job < Rao::Service::Configuration.job_base_class_name.constantize
      def perform(service_class_name, attributes = {}, options = {})
        service_class_name.constantize.call(attributes, options)
      end
    end
  end
end