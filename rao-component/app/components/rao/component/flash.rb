module Rao
  module Component
    class Flash < Base
      def initialize(context, options = {})
        super(context, options)
        @context = context
        @options = options
        @flash = @context.flash
        @mapped_flash = mapped_flash
        @view_locals = {
          mapped_flash: mapped_flash
        }
      end

      def render
        perform
      end

      private

      def mapped_flash
        @context.flash.each_with_object({}) do |(key, value), memo|
          memo[map_message_type_to_context(key)] = value
        end
      end

      def map_message_type_to_context(message_type)
        {success: "success", error: "danger", alert: "warning", notice: "info"}[message_type.to_sym] || message_type.to_s
      end
    end
  end
end