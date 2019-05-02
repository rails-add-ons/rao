module Rao
  module ResourcesController::WillPaginateConcern
    extend ActiveSupport::Concern

    included do
      helper_method :paginate?
    end

    def paginate?
      true
    end

    private

    def load_collection
      options = { page: params[:page] }
      options[:per_page] = per_page
      @collection = load_collection_scope.paginate(options)
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
