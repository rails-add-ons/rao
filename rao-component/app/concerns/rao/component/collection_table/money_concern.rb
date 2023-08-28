module Rao
  module Component
    module CollectionTable::MoneyConcern
      extend ActiveSupport::Concern

      def money(name, options = {}, &block)
        options.reverse_merge!(render_as: :money)
        column(name, options, &block)
      end
    end
  end
end