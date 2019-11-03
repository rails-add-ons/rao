module Rao
  module Query
    class ConditionParser
      def initialize(scope, field, condition)
        @scope, @field, @condition = scope, field, condition
      end

      def condition_statement
        build_condition_statement(@field, @condition)
      end

      private

      def build_condition_statement(parent_key, condition, nested = false)
        if is_a_condition?(parent_key) && !nested
          table, column, operator = extract_table_column_and_operator(parent_key)
          return handle_null_condition(column, operator, condition) if is_null_operator?(operator)
          if operator == 'cont'
            return ["#{table}.#{column} LIKE ?", "%#{normalized_condition(table, column, condition)}%"]
          else
            return ["#{table}.#{column} = ?", normalized_condition(table, column, condition)]
          end
        else
          if nested
            column = extract_column(parent_key)
            { column => condition }
          else
            { parent_key => build_condition_statement(condition.first[0], condition.first[1], true) }
          end
        end
      end

      def is_null_operator?(operator)
        %w(null not_null).include?(operator)
      end

      # We build the condition for booleans here.
      #
      # | operator   | condition | result        |
      # | 'null'     | true      | 'IS NULL'     |
      # | 'null'     | false     | 'IS NOT NULL' |
      # | 'not_null' | true      | 'IS NOT NULL' |
      # | 'not_null' | false     | 'IS NULL'     |
      #
      def handle_null_condition(column, operator, condition)
        if (operator == "null" && to_boolean(condition) == true) || (operator == "not_null" && to_boolean(condition) == false)
          "#{column} IS NULL"
        else
          "#{column} IS NOT NULL"
        end
      end

      def is_a_condition?(obj)
        !!extract_operator(obj)
      end

      def extract_operator(obj)
        string = obj.to_s
        operator_map.each do |key, value|
          return value if string.end_with?("(#{key})")
        end
        nil
      end

      def extract_column(obj)
        obj.to_s.split("(").first
      end

      # def extract_column_and_operator(string)
      #   if string =~ /([\.a-z_]{1,})\(([a-z_]{2,})\)/
      #     return $~[1], $~[2]
      #   end
      # end

      def extract_table_column_and_operator(string)
        if string =~ /([\.a-z_]{1,})\(([a-z_]{2,})\)/
          table_and_column = $~[1]
          operator = $~[2]
          column, table_or_association = table_and_column.split('.').reverse
          if table_or_association.nil?
            table = @scope.table_name
          else
            table = tables_and_classes_with_associations[table_or_association].table_name
          end
          return table, column, operator
        end
      end

      def operator_map
        Rao::Query::Operators::MAP
      end

      def column_is_boolean?(table_name, column_name)
        scope, column = get_scope_and_column_from_column_name(column_name, table_name)
        raise "Unknown column: #{column_name}" unless scope.columns_hash.has_key?(column)
        scope.columns_hash[column].type == :boolean
      end

      def get_scope_and_column_from_column_name(column_name, table_name = nil)
        if table_name == @scope.table_name
          return @scope, column_name
        else
          # tables_and_classes = @scope.reflect_on_all_associations.reject { |a| a.polymorphic? }.each_with_object({}) { |a, memo| memo[a.table_name] = a.klass }
          # associations_and_classes = @scope.reflect_on_all_associations.reject { |a| a.polymorphic? }.each_with_object({}) { |a, memo| memo[a.name.to_s] = a.klass }
          # scope = tables_and_classes.merge(associations_and_classes)[$~[1]]
          scope = tables_and_classes_with_associations[table_name]
          return scope, column_name
        end
      end

      def tables_and_classes_with_associations
        tables_and_classes = @scope.reflect_on_all_associations.reject { |a| (a.respond_to?(:polymorphic?) && a.polymorphic?) || a.options[:polymorphic] == true }.each_with_object({}) { |a, memo| memo[a.table_name] = a.klass }
        associations_and_classes = @scope.reflect_on_all_associations.reject { |a| (a.respond_to?(:polymorphic?) && a.polymorphic?) || a.options[:polymorphic] == true }.each_with_object({}) { |a, memo| memo[a.name.to_s] = a.klass }
        tables_and_classes.merge(associations_and_classes)
      end

      def to_boolean(string)
        case
        when Rails.version < '4.2'
          ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(string)
        when Rails.version < '5.0'
          ::ActiveRecord::Type::Boolean.new.type_cast_for_schema(string)
        else
          ::ActiveRecord::Type::Boolean.new.cast(string)
        end
      end

      def normalized_condition(table, column, condition)
        if column_is_boolean?(table, column)
          to_boolean(condition)
        else
          condition
        end
      end
    end
  end
end