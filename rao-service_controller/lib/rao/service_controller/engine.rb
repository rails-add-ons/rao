module Rao
  module ServiceController
    class Engine < ::Rails::Engine
      isolate_namespace Rao::ServiceController
    end
  end
end
