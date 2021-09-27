require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/attribute_accessors'

module Rao
  module Service
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:default_notification_sender)    { 'john.doe@domain.local' }
      mattr_accessor(:default_notification_recipient) { 'john.doe@domain.local' }
      mattr_accessor(:notification_environment)       { Object.const_defined?('::Rails') ? ::Rails.env : nil }
      mattr_accessor(:job_base_class_name)            { 'ActiveJob::Base' }
    end
  end
end