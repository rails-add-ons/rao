module Rao
  module Api
    module ServiceController::SerializationConcern
      extend ActiveSupport::Concern

      private

      def serialize_result(result)
        result.as_json(except: ['service'])
      end

      def serialize_errors(errors)
        errors
      end
    end
  end
end