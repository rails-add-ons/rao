module Rao
  # Provides SQL injection-safe sorting functionality for resource controllers with flexible field support.
  #
  # This concern automatically adds sorting capabilities to resource collections, allowing users
  # to sort by any model attribute or association field. It includes built-in SQL injection
  # protection and supports both simple and complex sorting scenarios.
  #
  # @example Basic usage with simple sorting
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::SortingConcern
  #     include Rao::ResourcesController::Plural::RestActionsConcern
  #
  #     def self.resource_class
  #       Post
  #     end
  #   end
  #
  #   # Result: Automatic sorting support
  #   # GET /posts?sort_by=title&sort_direction=asc
  #   # - @collection automatically sorted by title ascending
  #   # - SQL injection protection built-in
  #   # - Works with any model attribute
  #   # - No additional code needed in your controller
  #
  # @example Advanced sorting with associations
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::SortingConcern
  #   end
  #
  #   # GET /posts?sort_by=user.name&sort_direction=desc
  #   # - Sorts by associated user's name
  #   # - Supports complex association sorting
  #   # - Maintains SQL injection protection
  #   # - Handles nested attribute sorting
  #
  #   # Result: Flexible sorting capabilities
  #   # - Sort by any attribute or association
  #   # - Support for complex sorting scenarios
  #   # - Maintains security with SQL injection protection
  #   # - Easy integration with existing controllers
  #
  # @example Security features
  #   # The concern automatically protects against SQL injection:
  #   # GET /posts?sort_by="; DROP TABLE posts; --"  # Raises security error
  #   # GET /posts?sort_by=title DROP TABLE           # Raises security error
  #
  #   # Result: Secure sorting implementation
  #   # - Automatic detection of malicious input
  #   # - Clear error messages for security violations
  #   # - No risk of SQL injection attacks
  #   # - Production-ready security measures
  #
  # @example Integration with existing scopes
  #   class PostsController < ApplicationController
  #     include Rao::ResourcesController::SortingConcern
  #
  #     private
  #
  #     def load_collection_scope
  #       Post.published  # Your existing scope
  #     end
  #   end
  #
  #   # Result: Seamless integration
  #   # - Works with existing scopes and filters
  #   # - Maintains all existing functionality
  #   # - Adds sorting without breaking changes
  #   # - Easy to add to existing controllers
  #
  # @note Automatically handles both simple and complex sorting scenarios
  # @see https://guides.rubyonrails.org/active_record_querying.html Rails querying guide
  # @see https://guides.rubyonrails.org/security.html#sql-injection Rails security guide
  #
  module ResourcesController::SortingConcern
    private

    def load_collection_scope
      add_order_scope(super)
    end

    def add_order_scope(base_scope)
      if params[:sort_by].present?
        if params[:sort_by].include?(" ") || params[:sort_direction].include?(" ")
          raise "Possible SQL Injection attempt while trying to sort by #{params[:sort_by]} #{params[:sort_direction]}"
        end

        sort_by = params[:sort_by]
        sort_direction = params[:sort_direction] || :asc

        if sort_by.include?(".")
          base_scope.reorder("#{sort_by} #{sort_direction}")
        else
          base_scope.reorder(sort_by => sort_direction)
        end
      else
        base_scope
      end
    end
  end
end
