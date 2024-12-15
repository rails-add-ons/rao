module Rao
  module Component
    class Engine < ::Rails::Engine
      isolate_namespace Rao::Component
      
      initializer "rao.component.assets" do |app|
        app.config.assets.paths << root.join("app/assets")
      end
    end
  end
end