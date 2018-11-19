require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/attribute_accessors'

module Rao
  module Component
    module Configuration
      def configure
        yield self
      end
    end
  end
end