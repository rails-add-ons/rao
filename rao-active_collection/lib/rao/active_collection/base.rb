module Rao
  module ActiveCollection
    class Base
      class << self
        delegate :count , to: :all
      end
      
      def self.all
        Rao::ActiveCollection::Relation.new(self)
      end

      def self.collection
        []
      end
    end
  end
end
