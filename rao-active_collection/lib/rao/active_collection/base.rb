require "rao/active_collection/attribute_names_concern"
require "ostruct"

module Rao
  module ActiveCollection
    class Base
      include ActiveModel::Conversion
      include ActiveModel::Validations
      include ActiveModel::Dirty
      include AttributeNamesConcern

      def self.primary_key
        :id
      end

      class << self
        include Enumerable
        delegate :count, :delete_all, :find, :first, :first!, :order, :last, :last!, :page, :reorder, :where, to: :all
      end

      def self.inherited(base)
        klass = Class.new(Rao::ActiveCollection::Relation)
        base.const_set(:Relation, klass)
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
        self::Relation.new(self)
      end

      def self.collection
        @collection ||= {}.with_indifferent_access
      end

      def self.columns_hash
        @columns_hash ||= attribute_names.each_with_object({}.with_indifferent_access) do |attribute, hash|
          hash[attribute] = OpenStruct.new(name: attribute, type: String)
        end
      end

      def self.column_names
        columns_hash.keys.map(&:to_sym)
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

      def self.table_name
        name.underscore.tr("/", "_").pluralize
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
        # Initialize all attributes to nil first for proper dirty tracking
        self.class.attribute_names.each do |attr_name|
          instance_variable_set("@#{attr_name}", nil)
        end

        attributes.each do |key, value|
          send("#{key}=", value)
        end
        @new_record = true
        @destroyed = false

        # Mark all attributes as not changed initially
        # We need to call changes_applied after setting initial values
        changes_applied
      end

      # Store original values for reload functionality
      def store_original_values
        @original_values = {}
        self.class.attribute_names.each do |attr_name|
          @original_values[attr_name] = send(attr_name)
        end
      end

      def self.limit(limit)
        self::Relation.new(self).limit(limit)
      end

      def new_record?
        !!@new_record
      end

      def self.offset(offset)
        self::Relation.new(self).offset(offset)
      end

      def persisted?
        !(new_record? || destroyed?)
      end

      def reload
        # Use stored original values for reload functionality
        if persisted? && @original_values
          # Apply the stored original values
          @original_values.each do |key, value|
            send("#{key}=", value)
          end
          
          # Mark changes as applied to establish new baseline
          changes_applied
        end

        self
      end

      def save
        send("#{self.class.primary_key}=", self.class.generate_primary_key(self))
        return unless valid?
        @new_record = false
        changes_applied
        store_original_values
        self.class.collection[send(self.class.primary_key)] = self
      end

      def save!
        save || raise(ActiveRecord::RecordInvalid.new(self))
      end

      def update(attributes)
        attributes.each do |key, value|
          send("#{key}=", value)
        end
        save
      end

      # mark as changed when a setter is called

      private

      attr_writer :new_record
    end
  end
end
