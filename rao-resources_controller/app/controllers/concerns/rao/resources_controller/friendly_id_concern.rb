module Rao
  # Provides SEO-friendly URL support for resource controllers using FriendlyId.
  #
  # This concern automatically extends the resource loading scope to use FriendlyId's
  # friendly URL resolution, allowing controllers to work with both numeric IDs and
  # human-readable slugs. It seamlessly integrates with existing resource loading logic.
  #
  # @example Basic usage with slug-based URLs
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::FriendlyIdConcern
  #     include Rao::ResourcesController::Plural::RestActionsConcern
  #
  #     def self.resource_class
  #       Post
  #     end
  #   end
  #
  #   # Result: Automatic friendly URL resolution
  #   # GET /posts/my-awesome-blog-post (instead of /posts/123)
  #   # - Automatically finds posts by slug in both collection and individual lookups
  #   # - Maintains backward compatibility with numeric IDs
  #   # - Improves SEO with human-readable URLs
  #   # - No changes needed to existing controller logic
  #
  # @example SEO benefits for content management
  #   class ArticlesController < ApplicationController
  #     include Rao::ResourcesController::FriendlyIdConcern
  #   end
  #
  #   # URLs become:
  #   # /articles/getting-started-with-rails (instead of /articles/1)
  #   # /articles/advanced-ruby-patterns (instead of /articles/2)
  #
  #   # Result: Enhanced SEO and user experience
  #   # - Search engines can better understand content from URLs
  #   # - Users can share meaningful links
  #   # - URLs are more memorable and professional
  #   # - Improved click-through rates from search results
  #
  # @example Automatic fallback handling
  #   # The concern handles both slug and ID lookups automatically:
  #   # GET /posts/my-slug     # Finds by slug
  #   # GET /posts/123         # Falls back to ID lookup
  #   # GET /posts/            # Collection still works normally
  #
  #   # Result: Robust URL handling
  #   # - No breaking changes to existing functionality
  #   # - Graceful fallback for edge cases
  #   # - Maintains API compatibility
  #   # - Reduces maintenance overhead
  #
  # @note Requires FriendlyId gem and slug setup on your models
  # @see https://github.com/norman/friendly_id FriendlyId documentation
  # @see https://github.com/norman/friendly_id/wiki/Getting-started FriendlyId getting started
  #
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
