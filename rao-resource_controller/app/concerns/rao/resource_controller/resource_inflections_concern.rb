module Rao
  module ResourceController::ResourceInflectionsConcern
    extend ActiveSupport::Concern

    included do
      helper_method :inflections
    end

    private

    def inflections
      {
        resource_name: resource_class.model_name.human(count: 1),
        collection_name: resource_class.model_name.human(count: 2)
      }
    end
  end
end