$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "../lib/rao/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rao-shoulda_matchers"
  spec.version     = Rao::VERSION
  spec.authors     = ["Roberto Vasquez Angel"]
  spec.email       = ["roberto@vasquez-angel.de"]
  spec.homepage    = "https://github.com/rao"
  spec.summary     = "Additional shoulda matchers for Ruby on Rails."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency "rao"

  spec.add_development_dependency "sqlite3", "~> 2.1"
  spec.add_development_dependency "rails-dummy"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "pry"

  # dummy app
  spec.add_development_dependency "rails", "8.0.2"
  spec.add_development_dependency "bootsnap"
  spec.add_development_dependency "coffee-rails", "~> 4.2"
  spec.add_development_dependency "turbolinks", "~> 5"
  spec.add_development_dependency "jbuilder", "~> 2.5"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "web-console", ">= 3.3.0"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "sass-rails", "~> 5.0"
  spec.add_development_dependency "uglifier", ">= 1.3.0"
end
