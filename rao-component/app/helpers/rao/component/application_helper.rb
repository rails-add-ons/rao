module Rao
  module Component
    # Provides helpers to render tables for collections and single resources.
    # To use it you have to add it to your controller:
    #
    # Example:
    #
    #     class PostsController < ApplicationController
    #       #...
    #       helper Rao::Component::ApplicationHelper
    #     end
    #
    module ApplicationHelper
      def collection_table(options = {}, &block)
        Rao::Component::CollectionTable.new(self, options, &block).perform
      end

      def resource_table(options = {}, &block)
        Rao::Component::ResourceTable.new(self, options, &block).perform
      end

      def sort_link(column_name, title, options = {})
        return title if options === false
        SortLink.new(self, column_name, title, options).perform
      end

      class SortLink
        ARROW_UP   = '&#9650;'
        ARROW_DOWN = '&#9660;'

        def initialize(view_context, column_name, title, options)
          default_options = {}

          if options === true
            @options = default_options
          else
            @options = options.reverse_merge(default_options)
          end

          @view_context = view_context
          @column_name  = @options[:column_name] || column_name
          @title        = title

          if h.params[:sort_direction].present?
            @sort_direction = sorted_ascending? ? :desc : :asc
          else
            @sort_direction = :asc
          end

          if sorted_by_this_column?
            if sorted_ascending?
              @title_with_arrow = add_arrow_up(@title)
            else
              @title_with_arrow = add_arrow_down(@title)
            end
          else
            @title_with_arrow = @title
          end
        end

        def perform
          h.link_to(@title_with_arrow, h.url_for(h.request.query_parameters.merge(sort_by: @column_name, sort_direction: @sort_direction)))
        end

        private

        def h
          @view_context
        end

        def sorted_by_this_column?
          h.params[:sort_by] == @column_name.to_s
        end

        def sorted_ascending?
          h.params[:sort_direction].to_sym == :asc
        end

        def add_arrow_up(title)
          "#{title} #{ARROW_UP}".html_safe
        end

        def add_arrow_down(title)
          "#{title} #{ARROW_DOWN}".html_safe
        end
      end
    end
  end
end