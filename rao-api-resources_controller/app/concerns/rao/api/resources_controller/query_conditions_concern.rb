module Rao
  module Api
    module ResourcesController::QueryConditionsConcern
      private

      def add_conditions_from_query(scope)
        request.query_parameters.each do |field, condition|
          case field
          when 'limit'
            scope = scope.limit(condition.to_i)
          when 'offset'
            scope = scope.offset(condition.to_i)
          when 'order'
            scope = scope.order(condition)
          when 'includes'
            scope = scope.includes(condition.map(&:to_sym))
          when 'scopes'
            condition.each do |scope_name|
              scope = scope.send(scope_name.to_sym)
            end
          else
            condition_statement = ::Rao::Api::ResourcesController::ConditionParser.new(scope, field, condition).condition_statement
            scope = scope.where(condition_statement)
          end
        end
        scope
      end
    end
  end
end