module Rao
  module Component
    class Engine < ::Rails::Engine
      isolate_namespace Rao::Component

      initializer "rao_component.importmap", before: "importmap" do |app|
        if defined?(Importmap)
          puts "[Rao:Component] Adding importmap paths"
          app.config.importmap.paths << root.join("config/importmap.rb")
          app.config.importmap.cache_sweepers << root.join("app/javascript")
        end
      end

      # Ensure asset server (Propshaft/Sprockets) can find JS files
      initializer "rao_component.assets" do |app|
        app.config.assets.paths << root.join("app/javascript")
      end
    end
  end
end