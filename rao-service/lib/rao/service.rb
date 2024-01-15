begin
  require "active_job"
rescue LoadError => e
end

require "rao/service/configuration"
require "rao/service/version"

module Rao
  module Service
    extend Configuration
    
    class_eval do
      def self.rails_present?
        Object.const_defined?('::Rails')
      end
      def self.active_job_present?
        Object.const_defined?('::ActiveJob')
      end
    end
  end
end

require "rao/service/engine" if Rao::Service.rails_present?
require "rao/service/base"
require "rao/service/job" if Rao::Service.active_job_present?

Rao.configure { |c| c.register_configuration(:service, Rao::Service) }