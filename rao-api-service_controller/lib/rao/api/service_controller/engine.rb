module Rao
  module Api
    module ServiceController
      class Engine < ::Rails::Engine
        isolate_namespace Rao::Api::ServiceController
      end
    end
  end
end