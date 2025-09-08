$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "../lib/rao/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rao-api-service_controller"
  spec.version     = Rao::VERSION
  spec.authors     = ["Roberto Vasquez Angel"]
  spec.email       = ["roberto@vasquez-angel.de"]
  spec.homepage    = "https://github.com/rao"
  spec.summary     = "API Services Controller for Ruby on Rails."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency "rails", ">= 8.0"
  spec.add_dependency "rao"
  spec.add_dependency "rao-service"
  spec.add_dependency "responders"

  spec.add_development_dependency "sqlite3", "~> 2.1"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "rails-dummy"
  spec.add_development_dependency "bootsnap"
  spec.add_development_dependency "pry-rails"
end
