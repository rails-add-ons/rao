require "rao-view_helper"

require "rao/query/version"
require "rao/query/configuration"
require "rao/query/engine"
require "rao/query/operators"

module Rao
  module Query
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:query, Rao::Query) }