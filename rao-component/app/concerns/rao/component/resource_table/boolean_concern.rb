module Rao
  module Component
    module ResourceTable::BooleanConcern
      extend ActiveSupport::Concern

      def boolean(name, options = {}, &block)
        options.reverse_merge!(render_as: :boolean)
        row(name, options, &block)
      end
    end
  end
end