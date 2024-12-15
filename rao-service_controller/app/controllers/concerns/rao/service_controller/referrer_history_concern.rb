module Rao
  module ServiceController
    # This module provides functionality to store and manage a history of referrer URLs
    # in a Rails controller. It includes methods to store the referrer, retrieve the
    # most recent referrer, and prune the referrer history to a configurable maximum size.
    #
    # Usage:
    # Include this concern in your Rails controller to automatically store and manage
    # referrer URLs. You can access the most recent referrer using the `referrer` method.
    #
    # Example:
    # class MyController < ApplicationController
    #   include ResourcesController::ReferrerHistoryConcern
    #
    #   def some_action
    #     # Access the most recent referrer
    #     recent_referrer = referrer
    #     # Do something with the recent referrer
    #   end
    # end
    #
    # Configuration:
    # - `max_referrer_history_size`: The maximum number of referrer URLs to store in the history.
    #   Default is 3.
    #
    # Methods:
    # - `store_referrer`: Stores the current request's referrer URL into the history.
    # - `referrer_history`: Retrieves the session-based referrer history.
    # - `most_recent_referrer`: Returns the most recent referrer stored in the history.
    # - `referrer`: Alias for `most_recent_referrer`.
    # - `prune_referrer_history(max_size)`: Prunes the referrer history to the specified maximum size.
    # - `max_referrer_history_size`: Returns the configurable maximum size of the referrer history.
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
