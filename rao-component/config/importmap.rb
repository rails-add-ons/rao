# frozen_string_literal: true

# Importmap configuration for rao-component gem
pin_all_from Rao::Component::Engine.root.join("app/javascript/rao-component"), under: "rao-component"

# No external dependencies required - using vanilla JavaScript for drag & drop functionality