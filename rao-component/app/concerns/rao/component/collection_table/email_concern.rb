module Rao
  module Component
    module CollectionTable::EmailConcern
      extend ActiveSupport::Concern

      def email(name, options = {}, &block)
        options.reverse_merge!(render_as: :email)
        column(name, options, &block)
      end
    end
  end
end