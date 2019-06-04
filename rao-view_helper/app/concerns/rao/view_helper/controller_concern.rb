module Rao
  module ViewHelper
    module ControllerConcern
      extend ActiveSupport::Concern

      module ClassMethods
        def view_helper(klass, options = {})
          method_name = options.delete(:as) || klass.name.underscore.gsub('/', '_')
          define_method method_name do |context|
            klass.new(context)
          end
          helper_method method_name
        end
      end
    end
  end
end