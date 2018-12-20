module Rao
  module ViewHelper
    module Configuration
      def configure
        yield self
      end
    end
  end
end