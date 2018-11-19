module Rao
  module Component
    module CollectionTable::AwesomeNestedSetConcern
      extend ActiveSupport::Concern

      def awesome_nested_set_actions(name, options = {}, &block)
        options.reverse_merge!(render_as: :awesome_nested_set, scope: nil, title: t('.column_titles.awesome_nested_set'))
        column(name, options, &block)
      end
    end
  end
end