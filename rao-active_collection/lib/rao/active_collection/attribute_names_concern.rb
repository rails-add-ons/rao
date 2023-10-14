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
            attribute_names << attr_name
          end
        end

        def attribute_names
          (@attr_names ||= [])
        end
      end
    end
  end
end
