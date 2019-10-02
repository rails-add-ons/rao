require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/attribute_accessors'

module Rao
  module ServiceChain
    module Configuration
      def configure
        yield self
      end
    end
  end
end