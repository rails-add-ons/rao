module Rao
  module Component
    module ResourceTable::MoneyConcern
      extend ActiveSupport::Concern

      def money(name, options = {}, &block)
        options.reverse_merge!(render_as: :money)
        row(name, options, &block)
      end
    end
  end
end