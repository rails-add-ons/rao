module Rao
  module Component
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:table_default_timestamp_format) { nil }
    end
  end
end