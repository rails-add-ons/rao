module Rao
  module ResourceController
    class Engine < ::Rails::Engine
      isolate_namespace Rao::ResourceController
    end
  end
end
