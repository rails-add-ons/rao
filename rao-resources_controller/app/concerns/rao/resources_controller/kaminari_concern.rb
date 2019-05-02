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
      if [nil, 'all'].include?(params[:per_page])
        load_collection_scope.count
      else
        Rao::ResourcesController::Configuration.pagination_per_page_default
      end
    end
  end
end
