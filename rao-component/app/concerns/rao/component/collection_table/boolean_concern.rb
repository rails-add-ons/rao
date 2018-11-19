module Rao
  module Component
    module CollectionTable::BooleanConcern
      extend ActiveSupport::Concern

      def boolean(name, options = {}, &block)
        options.reverse_merge!(render_as: :boolean)
        column(name, options, &block)
      end
    end
  end
end