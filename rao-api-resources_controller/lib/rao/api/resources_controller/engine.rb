module Rao
  module Api
    module ResourcesController
      class Engine < ::Rails::Engine
        isolate_namespace Rao::Api::ResourcesController
      end
    end
  end
end