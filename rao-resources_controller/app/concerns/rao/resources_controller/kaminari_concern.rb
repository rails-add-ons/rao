module Rao
  module ResourcesController::KaminariConcern
    def self.included(base)
      base.helper_method :paginate?
    end

    def paginate?
      true
    end

    private

    def load_collection
      @collection = load_collection_scope.page(params[:page])
    end
  end
end
