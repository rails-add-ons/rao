module Rao
  module ServiceController
    module InflectionsConcern
      extend ActiveSupport::Concern

      included do
        helper_method :inflections
      end
  
      private
  
      def inflections
        {
          service_name: service_class.model_name.human
        }
      end
    end
  end
end
