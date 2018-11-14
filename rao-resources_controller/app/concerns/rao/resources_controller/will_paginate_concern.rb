module Rao
  # Setting the pagination size in the controller:
  #
  #     # app/controllers/posts_controller.rb
  #     class PostsController < ApplicationController
  #       # ...
  #       private
  #
  #       def per_page
  #         15
  #       end
  #     end
  #
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
      options[:per_page] = per_page if respond_to?(:per_page, true)
      @collection = load_collection_scope.paginate(options)
    end
  end
end
