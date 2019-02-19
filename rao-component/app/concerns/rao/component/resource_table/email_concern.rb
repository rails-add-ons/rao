module Rao
  module Component
    module ResourceTable::EmailConcern
      extend ActiveSupport::Concern

      def email(name, options = {}, &block)
        options.reverse_merge!(render_as: :email)
        row(name, options, &block)
      end
    end
  end
end