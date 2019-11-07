module Rao
  module Service::Message
    class Base
      def initialize(content, options = {})
        @indent_level = options.fetch(:indent_level) { 0 }
        @prefix = options.fetch(:prefix) { nil }
        @suffix = options.fetch(:suffix) { nil }
        @content = content
      end

      def level
        @indent_level
      end

      def to_s
        "[#{@prefix}] #{("  " * @indent_level)}#{@content}#{@suffix}"
      end

      def content
        @content.to_s
      end
    end
  end
end