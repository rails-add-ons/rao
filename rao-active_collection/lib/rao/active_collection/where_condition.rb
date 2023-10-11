module Rao
  module ActiveCollection
    class WhereCondition
      attr_accessor :relation, :conditions

      def initialize(relation, conditions)
        @relation = relation
        @conditions = conditions
      end

      def result
        case @conditions
        when Hash
          @conditions.each do |key, value|
            apply_condition(key, value)
          end
        else
          raise "Unsupported condition type: #{conditions.class.name}"
        end
        @relation
      end

      private

      def apply_condition(key, value)
        @relation.collection = @relation.collection.select do |id, item|
          item.send(key) == value
        end
      end
    end
  end
end
