module Rao
  module Component
    module CollectionTable::ActsAsPublishedConcern
      extend ActiveSupport::Concern

      def acts_as_published_actions(options = {}, &block)
        options.reverse_merge!(render_as: :acts_as_published, title: t('.column_titles.acts_as_published'))
        column(:acts_as_published_actions, options, &block)
      end
    end
  end
end