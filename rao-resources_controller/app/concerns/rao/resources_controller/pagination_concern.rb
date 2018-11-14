module Rao
  module ResourcesController::PaginationConcern
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
