module Rao
  module ServiceChain
    class Engine < ::Rails::Engine
      isolate_namespace Rao::ServiceChain
    end
  end
end