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
        options[:actions] ||= instance_exec(&Rao::Component::Configuration.batch_actions_default_actions)
        title = @view.render partial: 'rao/component/table/header_cells/batch_actions', locals: { options: options }
        options.reverse_merge!(render_as: :batch_actions, title: title)
        column(:batch_actions, options, &block)
      end
    end
  end
end