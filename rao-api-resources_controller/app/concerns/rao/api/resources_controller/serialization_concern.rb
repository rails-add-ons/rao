module Rao
  module Api
    module ResourcesController::SerializationConcern
      extend ActiveSupport::Concern

      private

      def serialize_collection(collection)
        collection.collect do |resource|
          serialize_resource(resource)
        end
      end

      def serialize_resource(resource)
        json = resource.as_json
        json[:errors] = serialize_errors(resource.errors) if resource.errors.any?
        json
      end

      def serialize_errors(errors, full_messages: true)
        errors.as_json(full_messages: full_messages)
      end
    end
  end
end