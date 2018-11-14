module Rao
  module ResourcesController
    module Configuration
      def configure
        yield self
      end
    end
  end
end