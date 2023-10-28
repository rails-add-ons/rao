module Rao
  module ActiveCollection
    class Relation
      include Enumerable

      attr_accessor :collection

      delegate :columns_hash, :table_name, to: :@klass

      def initialize(klass)
        @klass = klass
        @collection = klass.collection
        @conditions = []
        @order = []
        @page = nil
        @per = nil
        @limit = nil
        @offset = nil
      end

      def to_a
        transform_page_and_per_to_limit_and_offset! if @page
        apply_limit(apply_offset(@collection.values))
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
        first || raise(ActiveRecord::RecordNotFound, "Couldn't find #{table_name} with conditions: #{@conditions.map(&:conditions)}}")
      end

      def last
        all.collection.values.last
      end

      def last!
        last || raise(ActiveRecord::RecordNotFound)
      end

      def limit(limit)
        @limit = limit
        self
      end

      def offset(offset)
        @offset = offset
        self
      end

      def order(condition)
        @order << OrderCondition.new(self, condition)
        self
      end

      def page(page)
        @page = page
        self
      end

      def per(per)
        @per = per
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

      def apply_offset(collection)
        return collection unless @offset
        collection.drop(@offset)
      end

      def apply_limit(collection)
        return collection unless @limit
        collection.first(@limit)
      end

      def transform_page_and_per_to_limit_and_offset!
        @limit = @per
        @offset = (@page - 1) * @per
      end
    end
  end
end
