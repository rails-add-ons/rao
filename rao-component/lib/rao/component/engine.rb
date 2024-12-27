module Rao
  module Component
    class Engine < ::Rails::Engine
      isolate_namespace Rao::Component
    end
  end
end