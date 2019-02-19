module Rao
  module Component
    module ResourceTable::DateConcern
      extend ActiveSupport::Concern

      def date(name, options = {}, &block)
        options.reverse_merge!(render_as: :date, format: Rao::Component::Configuration.table_default_date_format)
        row(name, options, &block)
      end
    end
  end
end