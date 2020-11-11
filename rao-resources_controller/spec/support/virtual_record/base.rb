module VirtualRecord
  class Base
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    def self.attribute_names
      [:id]
    end

    attr_accessor *attribute_names
    attr_reader   :errors


    def self.first
      all.first
    end

    def self.store
      @all ||= {}
    end

    def self.all
      store.values
    end

    def self.destroy_all
      all.collect { |r| r.destroy }
    end

  def self.create(attributes = {})
    record = new(attributes)
    record.save
    record
  end

    def destroy
      self.class.all.delete(id)
      self.id = nil
      self
    end

    def update(attributes)
      attributes.each do |k,v|
        send("#{k}=", v)
      end
      save
    end

    def save
      return false unless valid?
      self.id ||= SecureRandom.uuid
      self.class.store[self.id] = self
      true
    end

    def self.find(id)
      @all[id]
    end

    def initialize(attributes = {})
      @errors = ActiveModel::Errors.new(self)
      attributes.each do |k,v|
        send("#{k}=", v)
      end
    end

    def persisted?
      self.id.present?
    end

    def new_record?
      !persisted?
    end
  end
end
