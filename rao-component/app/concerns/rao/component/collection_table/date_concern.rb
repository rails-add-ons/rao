module Rao
  module Component
    module CollectionTable::DateConcern
      extend ActiveSupport::Concern

      def date(name, options = {}, &block)
        options.reverse_merge!(render_as: :date, format: Rao::Component::Configuration.table_default_date_format)
        column(name, options, &block)
      end
    end
  end
end