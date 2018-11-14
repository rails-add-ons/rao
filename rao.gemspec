$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rao/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rao"
  s.version     = Rao::VERSION
  s.authors     = ["Roberto Vasquez Angel"]
  s.email       = ["roberto@vasquez-angel.de"]
  s.summary     = "Rails Add Ons."
  s.description = "The missing bits."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-bundler'
end
