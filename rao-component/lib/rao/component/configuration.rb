module Rao
  module Component
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:table_default_timestamp_format) { nil }
      mattr_accessor(:table_default_date_format) { nil }
      mattr_accessor(:image_variant_options) {
        {
          collection: { resize: "160x120" },
          resource:   { resize: "320x240" }
        }
      }
      mattr_accessor(:batch_actions_default_actions) do
        -> {
          { destroy_many: @view.url_for(action: :destroy_many) }
        }
      end
    end
  end
end