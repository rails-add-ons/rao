# frozen_string_literal: true

# Asset pipeline configuration no longer needed with importmaps
# JavaScript modules are now served directly via app/javascript/
if Rails.application.config.respond_to?(:assets)
  # Rails.application.config.assets.precompile += %w( rao-component/*.js )
end
