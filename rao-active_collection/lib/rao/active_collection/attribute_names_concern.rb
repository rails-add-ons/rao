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
          ensure_attribute_dirty_tracking!
        end

        def attr_reader(*args)
          super
          add_attribute_names(*args)
        end

        def attr_writer(*args)
          super
          ensure_attribute_dirty_tracking!
        end

        def add_attribute_names(*args)
          args.each do |attr_name|
            attribute_names << attr_name.to_sym
          end
        end

        def attribute_names
          (@attr_names ||= [])
        end

        def ensure_attribute_dirty_tracking!
          attribute_names.each do |attr_name|
            define_method("#{attr_name}=") do |value|
              instance_variable_set("@#{attr_name}", value)
              send("#{attr_name}_will_change!")
            end
          end
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
