module Rao
  module ViewHelper
    class Engine < ::Rails::Engine
      isolate_namespace Rao::ViewHelper
    end
  end
end