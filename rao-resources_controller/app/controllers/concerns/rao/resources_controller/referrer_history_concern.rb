module Rao
  module ResourcesController
    # Provides referrer URL history tracking for resource controllers with intelligent navigation support.
    #
    # This concern automatically tracks and manages a history of referrer URLs in the session,
    # allowing controllers to provide intelligent "back" functionality and maintain context
    # across complex navigation patterns. It's particularly useful for admin interfaces and
    # multi-step workflows where users need to navigate back through their journey.
    #
    # @example Basic usage with referrer tracking
    #   class PostsController < ApplicationController
    #     include Rao::ResourcesController::ReferrerHistoryConcern
    #     include Rao::ResourcesController::Plural::RestActionsConcern
    #
    #     def self.resource_class
    #       Post
    #     end
    #   end
    #
    #   # Result: Automatic referrer history management
    #   # - Every page visit automatically stores referrer in session
    #   # - referrer helper method available in views and controllers
    #   # - Intelligent "back" functionality without browser dependency
    #   # - Maintains context across form submissions and redirects
    #
    # @example Smart redirect functionality
    #   class PostsController < ApplicationController
    #     include Rao::ResourcesController::ReferrerHistoryConcern
    #
    #     def create
    #       if @post.save
    #         redirect_to referrer || posts_path
    #       else
    #         render :new
    #       end
    #     end
    #   end
    #
    #   # Result: Context-aware navigation
    #   # - Users return to where they came from after creating posts
    #   # - Maintains workflow continuity in admin interfaces
    #   # - Reduces navigation friction for content managers
    #   # - Provides fallback to sensible defaults
    #
    # @example Multi-step workflow support
    #   # User journey: Admin → Posts → Edit Post → Save → Back to Posts
    #   # The concern automatically tracks this path and provides intelligent redirects
    #
    #   # Result: Seamless user experience
    #   # - No "dead ends" in complex workflows
    #   # - Users can navigate naturally through admin interfaces
    #   # - Maintains context across multiple operations
    #   # - Reduces cognitive load for content managers
    #
    # @example Session management features
    #   # - Automatically prunes history to prevent session bloat (keeps last 3 referrers)
    #   # - Handles edge cases like missing referrers gracefully
    #   # - Provides debugging information for development
    #   # - Maintains performance with large navigation histories
    #
    #   # Result: Robust session handling
    #   # - No memory leaks from unlimited history growth
    #   # - Graceful degradation when referrer is unavailable
    #   # - Development-friendly debugging output
    #   # - Optimal performance for production use
    #
    # @note Automatically handles both before_action and before_filter for Rails compatibility
    # @see https://guides.rubyonrails.org/action_controller_overview.html Rails controller guide
    #
    module ReferrerHistoryConcern
      extend ActiveSupport::Concern

      included do
        prepend_before_action :store_referrer
        helper_method :most_recent_referrer, :referrer
      end

      private

      # Stores the referrer URL into the referrer history with a timestamp.
      def store_referrer
        return if request.referer.nil?

        # Prune history to maintain the maximum size
        prune_referrer_history(max_referrer_history_size)

        logger.debug "[ReferrerHistoryConcern] Storing referrer [#{request.referer}]"
        referrer_history[Time.zone.now] = request.referer
      end

      # Retrieves the session-based referrer history or initializes it as an empty hash.
      def referrer_history
        session[:referrer_history] ||= {}
      end

      # Returns the most recent referrer stored in the history.
      def most_recent_referrer
        referrer_history.max_by { |timestamp, _url| timestamp }&.last
      end

      # Alias for most_recent_referrer to provide a concise alternative.
      alias_method :referrer, :most_recent_referrer

      # Prunes the referrer history to the specified maximum size.
      def prune_referrer_history(max_size)
        return if referrer_history.size <= max_size

        # Keep only the most recent entries
        pruned = referrer_history.sort_by { |timestamp, _| timestamp }.last(max_size)
        session[:referrer_history] = pruned.to_h
      end

      # Configurable maximum size of the referrer history.
      def max_referrer_history_size
        3
      end
    end
  end
end
