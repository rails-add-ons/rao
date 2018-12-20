module Rao
  module Query
    module Configuration
      def configure
        yield self
      end
    end
  end
end