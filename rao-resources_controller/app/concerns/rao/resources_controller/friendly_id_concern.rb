module Rao
  module ResourcesController::FriendlyIdConcern
    extend ActiveSupport::Concern

    private

    def load_collection_scope
      super.friendly
    end

    def load_resource_scope
      super.friendly
    end
  end
end
