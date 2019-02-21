module Rao
  module Query
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:default_query_params_exceptions) {  %w(sort_by sort_direction utf8 commit page locale) }
    end
  end
end