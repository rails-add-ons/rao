module Rao
  module Component
    module CollectionTable::ActsAsListConcern
      extend ActiveSupport::Concern

      def acts_as_list_actions(options = {}, &block)
        options.reverse_merge!(render_as: :acts_as_list, title: t('.column_titles.acts_as_list'), scope: nil)

        scope = options.delete(:scope)
        scope = "#{scope}_id".intern if scope.is_a?(Symbol) && scope.to_s !~ /_id$/

        options.merge(scope: scope)

        column(:acts_as_list_actions, options, &block)
      end
    end
  end
end