module Rao
  module ResourcesController
    class Engine < ::Rails::Engine
      isolate_namespace Rao::ResourcesController
    end
  end
end
