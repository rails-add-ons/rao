module Rao
  module ResourcesController
    module ResourceInflectionsConcern
      extend ActiveSupport::Concern

      included do
        helper_method :inflections
      end
  
      private
  
      def inflections
        {
          resource_name: resource_class.model_name.human,
          collection_name: resource_class.model_name.human(count: :other)
        }
      end
    end
  end
end
