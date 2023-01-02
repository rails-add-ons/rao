module Rao
  module Api
    module ResourceController::SerializationConcern
      extend ActiveSupport::Concern

      private

      def serialize_resource(resource)
        json = resource.as_json
        json[:errors] = serialize_errors(resource.errors) if resource.errors.any?
        json
      end

      def serialize_errors(errors)
        errors.as_json(full_messages: true)
      end
    end
  end
end