module Rao
  module Component
    module ResourceTable::ActiveStorageConcern
      extend ActiveSupport::Concern

      def attachment(name, options = {}, &block)
        options.reverse_merge!(render_as: :attachment)
        row(name, options, &block)
      end
    end
  end
end