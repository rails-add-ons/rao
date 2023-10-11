require "rao/active_collection/attribute_names_concern"

module Rao
  module ActiveCollection
    class Base
      include ActiveModel::Conversion
      include ActiveModel::Validations
      include AttributeNamesConcern

      def self.primary_key
        :id
      end

      class << self
        include Enumerable
        delegate :count, :delete_all, :find, :first, :first!, :order, :last, :last!, :reorder, :where, to: :all
      end

      def ==(other)
        self.class == other.class && send(self.class.primary_key) == other.send(self.class.primary_key)
      end

      def self.each
        # rubocop:disable Style/For
        for item in all.to_a do
          yield item
        end
        # rubocop:enable Style/For
      end

      def self.all
        Rao::ActiveCollection::Relation.new(self)
      end

      def self.collection
        @collection ||= {}.with_indifferent_access
      end

      def self.create(attributes = {})
        new(attributes).save
      end

      def self.create!(attributes = {})
        new(attributes).save!
      end

      def self.generate_primary_key(record = nil)
        (collection.keys.map(&:to_i).max || 0) + 1
      end

      def destroy
        @destroyed = true
        collection = self.class.instance_variable_get(:@collection)
        collection.delete(send(self.class.primary_key))
        self.class.instance_variable_set(:@collection, collection)
        self
      end

      def destroyed?
        !!@destroyed
      end

      def initialize(attributes = {})
        attributes.each do |key, value|
          send("#{key}=", value)
        end
        @new_record = true
        @destroyed = false
      end

      def new_record?
        !!@new_record
      end

      def persisted?
        !(new_record? || destroyed?)
      end

      def save
        send("#{self.class.primary_key}=", self.class.generate_primary_key(self))
        return unless valid?
        @new_record = false
        self.class.collection[send(self.class.primary_key)] = self
      end

      def save!
        save || raise(ActiveRecord::RecordInvalid.new(self))
      end

      private

      attr_writer :new_record
    end
  end
end
