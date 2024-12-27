module Rao
  module Service
    module Base::CallbacksConcern
      extend ActiveSupport::Concern

      def after_initialize; end
      def before_perform; end
      def after_perform; end
      def before_validation; end
      def after_validation; end
      def after_perform; end
      def around_perform
        yield
      end

      def perform(options = {})
        options.reverse_merge!(validate: true)
        validate = options.delete(:validate)
        if validate
          before_validation
          return perform_result unless valid?
          after_validation
        end
        before_perform
        around_perform do
          say "Performing" do
            _perform
          end
        end
        after_perform
        save if result.ok? && autosave? && respond_to?(:save, true)
        perform_result
      end
    end
  end
end
