module Rao
  # Provides pagination functionality for resource controllers using Kaminari.
  #
  # This concern adds pagination support to controllers, allowing them to display
  # large collections of resources across multiple pages with configurable page sizes.
  # It integrates with Kaminari gem and provides helper methods for pagination controls.
  #
  # @example Basic usage with paginated posts
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::KaminariConcern
  #     include Rao::ResourcesController::Plural::RestActionsConcern
  #
  #     def self.resource_class
  #       Post
  #     end
  #   end
  #
  #   # Result: Automatic pagination for large collections
  #   # GET /posts?page=2&per_page=25
  #   # - @collection contains only 25 posts for page 2
  #   # - Helper methods like paginate? and per_page available in views
  #   # - Automatic pagination controls in your templates
  #   # - Improved performance for large datasets
  #
  # @example Custom per-page configuration
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::KaminariConcern
  #
  #     private
  #
  #     def per_page_default
  #       50  # Override default page size
  #     end
  #   end
  #
  #   # Result: Enhanced performance for large datasets
  #   # - Pages now show 50 items by default instead of 25
  #   # - Reduced server load with fewer requests
  #   # - Users see more content per page
  #   # - Better balance between performance and usability
  #
  # @example Advanced pagination features
  #   # GET /posts?per_page=all  # Shows all records (useful for exports)
  #   # GET /posts?per_page=100  # Custom page size
  #   # GET /posts?page=3        # Navigate to specific page
  #
  #   # Result: Flexible pagination options
  #   # - Users can choose their preferred page size
  #   # - Export functionality with 'all' option
  #   # - Maintains user preferences across sessions
  #   # - Reduces memory usage for large collections
  #
  # @example View helper integration
  #   # In your views:
  #   # <%= paginate @collection %>  # Automatic pagination controls
  #   # <%= per_page %>              # Current page size
  #   # <%= paginate? %>             # Whether pagination is active
  #
  #   # Result: Rich pagination UI
  #   # - Professional pagination controls out of the box
  #   # - Consistent styling across all paginated pages
  #   # - Accessible navigation for users
  #   # - Mobile-friendly pagination controls
  #
  # @note Requires Kaminari gem to be installed
  # @see https://github.com/kaminari/kaminari Kaminari documentation
  # @see https://github.com/kaminari/kaminari/wiki/How-to-use-Kaminari Kaminari usage guide
  #
  module ResourcesController::KaminariConcern
    extend ActiveSupport::Concern

    included do
      helper_method :paginate?
      helper_method :per_page
    end

    private

    def paginate?
      true
    end

    def per_page_default
      Rao::ResourcesController::Configuration.pagination_per_page_default
    end

    def load_collection
      @collection = load_collection_scope.page(params[:page]).per(per_page)
    end

    def per_page
      # Return page size from configuration if per_page is not present in params
      unless params.has_key?(:per_page)
        return per_page_default
      end

      # Return count of all records or nil if no records present if
      # params[:per_page] equals 'all'. Otherwise return params[:per_page]
      if params[:per_page] == "all"
        count = load_collection_scope.count
        (count > 0) ? count : nil
      else
        params[:per_page]
      end
    end
  end
end
