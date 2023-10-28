module Rao
  module ActiveCollection
    class OrderCondition
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
        @relation.collection = if value.to_sym == :asc
          @relation.collection.sort_by { |a| a.last.send(key).to_s }.to_h
        else
          @relation.collection.sort_by { |a| a.last.send(key).to_s }.reverse.to_h
        end
      end
    end
  end
end
