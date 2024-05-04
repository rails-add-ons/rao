module Rao
  module Query
    module Controller
      # Example
      #
      #     # app/controllers/posts_controller.rb
      #     class PostsController < ApplicationController
      #       include Rao::Query::Controller::QueryConcern
      #
      #       def index
      #         @posts = with_conditions_from_query(Post).all
      #       end
      #     end
      #
      module QueryConcern
        extend ActiveSupport::Concern

        private

        def with_conditions_from_query(scope)
          if query_params.keys.include?('q')
            condition_params = normalize_query_params(query_params)
          else
            condition_params = query_params
          end

          condition_params.reject.reject { |k,v| v.blank? }.each do |field, condition|
            case field
            when 'limit'
              scope = scope.limit(condition.to_i)
            when 'offset'
              scope = scope.offset(condition.to_i)
            when 'order'
              scope = scope.order(condition)
            when 'includes'
              scope = scope.includes(condition.map(&:to_sym))
            when /(.*)\(scope\)/
              unless query_allowed_scopes.include?($1.to_sym)
                puts "[Rao::Query] Warning: Scope #{$1} is not allowed. Not applying scope."
                return scope
              end
              if condition == "null"
                scope = scope.send($1)
              else
                scope = scope.send($1, condition)
              end
            else
              condition_statement = ::Rao::Query::ConditionParser.new(scope, field, condition).condition_statement
              scope = scope.where(condition_statement)
            end
          end
          scope
        end

        def query_allowed_scopes
          []
        end

        def query_params
          default_query_params
        end

        def default_query_params
          request.query_parameters.except(*query_params_exceptions)
        end

        def query_params_exceptions
          @query_params_exceptions ||= Rao::Query::Configuration.default_query_params_exceptions
        end

        def normalize_query_params(params)
          return {} unless params['q'].respond_to?(:each_with_object)
          params['q'].each_with_object({}) { |(k, v), m| m[normalize_key(k)] = v }
        end

        def normalize_key(key)
          attribute_name, predicate = Rao::Query::Operators.extract_attribute_name_and_predicate_from_name(key)
          "#{attribute_name}(#{predicate})"
        end
      end
    end
  end
end
