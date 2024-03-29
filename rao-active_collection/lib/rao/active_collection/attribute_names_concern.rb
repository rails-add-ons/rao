module Rao
  module ActiveCollection
    module AttributeNamesConcern
      extend ActiveSupport::Concern

      included do
      end

      class_methods do
        def attr_accessor(*args)
          super
          add_attribute_names(*args)
          define_attribute_methods(*args)
        end

        def attr_reader(*args)
          super
          add_attribute_names(*args)
          define_attribute_methods(*args)
        end

        def add_attribute_names(*args)
          args.each do |attr_name|
            attribute_names << attr_name.to_sym
          end
        end

        def attribute_names
          (@attr_names ||= [])
        end
      end

      def attributes
        self.class.attribute_names.each_with_object({}.with_indifferent_access) do |attribute, hash|
          hash[attribute] = send(attribute)
        end
      end
    end
  end
end
