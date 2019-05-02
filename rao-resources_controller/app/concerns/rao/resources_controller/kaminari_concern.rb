module Rao
  module ResourcesController::KaminariConcern
    extend ActiveSupport::Concern

    included do
      helper_method :paginate?
    end

    def paginate?
      true
    end

    private

    def load_collection
      @collection = load_collection_scope.page(params[:page]).per(per_page)
    end

    def per_page
      # Return page size from configuration if per_page is not present in params
      unless params.has_key?(:per_page)
        return Rao::ResourcesController::Configuration.pagination_per_page_default
      end

      # Return count of all records or nil if no records present if
      # params[:per_page] equals 'all'. Otherwise return params[:per_page]
      if params[:per_page] == 'all'
        count = load_collection_scope.count
        count > 0 ? count : nil
      else
        params[:per_page]
      end
    end
  end
end
