module Rao
  module Query
    class Engine < ::Rails::Engine
      isolate_namespace Rao::Query
    end
  end
end