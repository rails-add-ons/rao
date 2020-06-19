module Rao
  module Component
    module CollectionTable::ActiveStorageConcern
      extend ActiveSupport::Concern

      def attachment(name, options = {}, &block)
        options.reverse_merge!(render_as: :attachment)
        column(name, options, &block)
      end
    end
  end
end