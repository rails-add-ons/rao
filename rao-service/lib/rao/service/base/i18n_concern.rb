module Rao
  module Service
    module Base::I18nConcern
      extend ActiveSupport::Concern

      def t(key, options = {})
        I18n.t("activemodel.#{self.class.name.underscore}#{key}", options)
      end
    end
  end
end
