module Rao
  module Service::Message
    class Base
      def initialize(content, options = {})
        @indent_level = options.fetch(:indent_level) { 1 }
        @content = content
      end

      def level
        @indent_level
      end

      def to_s
        @content
      end
    end
  end
end