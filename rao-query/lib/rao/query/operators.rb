module Rao
  module Query
    module Operators
      # The not operators have to go first. Else the matching will detect _null
      # or _eq before _not_null and _not_eq.
      MAP = {
        not_eq:   :'<>',
        not_null: :is_not_null,

        gt_or_eq: :>=,
        gt:       :>,
        lt_or_eq: :<=,
        lt:       :<,
        eq:       :'=',
        null:     :is_null,
        cont:     :like
      }

      def self.extract_attribute_name_and_predicate_from_name(name)
        MAP.keys.each do |predicate|
          if name.to_s.end_with?(predicate.to_s)
            attribute_name = name[0..-(predicate.length + 2)]
            return attribute_name, predicate
          end
        end
        
        raise "Could not extract attribute name and predicate from #{name}"
      end
    end
  end
end
