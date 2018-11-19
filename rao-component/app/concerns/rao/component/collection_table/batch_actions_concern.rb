module Rao
  module Component
    module CollectionTable::BatchActionsConcern
      extend ActiveSupport::Concern

      # Example:
      #
      #     = table.batch_actions(actions: { destroy: url_for(action: :destroy_many) })
      #
      def batch_actions(options = {}, &block)
        @wrap_in_form = true
        title = @view.render partial: 'component/table/header_cells/batch_actions', locals: { options: options }
        options.reverse_merge!(render_as: :batch_actions, title: title)
        column(:batch_actions, options, &block)
      end
    end
  end
end