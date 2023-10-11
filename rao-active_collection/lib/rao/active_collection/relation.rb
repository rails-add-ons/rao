module Rao
  module ActiveCollection
    class Relation
      include Enumerable

      attr_accessor :collection

      # delegate :size, to: :to_a

      def initialize(klass)
        @klass = klass
        @collection = klass.collection
        @conditions = []
        @order = []
      end

      def to_a
        @collection.values
      end

      def count
        all.to_a.size
      end

      def delete_all
        @deleted = all
        @klass.instance_variable_set(
          :@collection,
          @klass.collection.excluding(@deleted.map { |item| item.send(@klass.primary_key) })
        )
        @deleted
      end

      def each
        # rubocop:disable Style/For
        for item in all.to_a do
          yield item
        end
        # rubocop:enable Style/For
      end

      def where(conditions)
        @conditions << WhereCondition.new(self, conditions)
        self
      end

      def all
        @conditions.each do |condition|
          apply_condition(condition)
        end
        @order.each do |condition|
          apply_condition(condition)
        end
        self
      end

      def find(id)
        where(id: id).first || raise(ActiveRecord::RecordNotFound)
      end

      def first
        all.collection.values.first
      end

      def first!
        first || raise(ActiveRecord::RecordNotFound)
      end

      def last
        all.collection.values.last
      end

      def last!
        last || raise(ActiveRecord::RecordNotFound)
      end

      def order(condition)
        @order << OrderCondition.new(self, condition)
        self
      end

      def reorder(condition)
        @order = []
        order(condition)
        self
      end

      private

      def apply_condition(condition)
        relation = condition.result
        @collection = relation.collection
      end
    end
  end
end
