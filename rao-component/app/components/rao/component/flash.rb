module Rao
  module Component
    class Flash < Base
      def initialize(context, options = {})
        super(context, options)
        @context = context
        @options = options
        @flash = @context.flash
      end

      def render
        perform
      end
    end
  end
end