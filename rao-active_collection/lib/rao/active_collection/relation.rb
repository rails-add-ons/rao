module Rao
  module ActiveCollection
    class Relation
      def initialize(klass)
        @klass = klass
        @collection = klass.collection
      end

      def to_a
        @collection
      end

      def count
        @collection.size
      end
    end
  end
end
