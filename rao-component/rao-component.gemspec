# Use a unified version number for all gems in the rao namespace.
require_relative "../lib/rao/version"

Gem::Specification.new do |spec|
  spec.name        = "rao-component"
  spec.version     = Rao::VERSION
  spec.authors     = [ "Roberto Vasquez Angel" ]
  spec.email       = [ "rva@beegoodit.de" ]
  spec.homepage    = "https://github.com/rails-add-ons/rao-component"
  spec.summary     = "View Components for Ruby on Rails."
  spec.description = "Provides advanced view helpers/components for Ruby on Rails."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.0.alpha"

  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec-rails"
end
