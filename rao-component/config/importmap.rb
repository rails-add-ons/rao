# frozen_string_literal: true

# Importmap configuration for rao-component gem
pin_all_from Rao::Component::Engine.root.join("app/javascript/rao-component"), under: "rao-component"

# jQuery dependencies for drag & drop functionality
pin "jquery",    to: "https://esm.sh/jquery@3.7.1"
pin "jquery-ui", to: "https://esm.sh/jquery-ui@1.13.2?deps=jquery@3.7.1"