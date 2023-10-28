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
        when Array
          if @conditions.first.include?("LIKE")
            key = @conditions.first.split(" ").first.split(".").last
            value = @conditions.last
            apply_like_condition(key, value)
          else
            raise "Unsupported condition type: #{conditions.class.name}"
          end
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

      def apply_like_condition(key, value)
        @relation.collection = @relation.collection.select do |id, item|
          if value.start_with?("%") && value.end_with?("%")
            item.send(key).to_s.include?(value.delete("%"))
          elsif value.start_with?("%")
            item.send(key).to_s.end_with?(value.delete("%"))
          elsif value.end_with?("%")
            item.send(key).to_s.start_with?(value.delete("%"))
          end
        end
      end
    end
  end
end
