module Rao
  module Service
    class Engine < ::Rails::Engine
      isolate_namespace Rao::Service
    end
  end
end