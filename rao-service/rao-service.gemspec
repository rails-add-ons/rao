$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "../lib/rao/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rao-service"
  s.version     = Rao::VERSION
  s.authors     = ["Roberto Vasquez Angel"]
  s.email       = ["roberto@vasquez-angel.de"]
  s.homepage    = "https://github.com/rao"
  s.summary     = "Services for Ruby on Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = '>= 2.6.6'

  s.add_dependency "rails", ">= 6.0.0.0"
  s.add_dependency "activesupport"
  s.add_dependency "activemodel"
  s.add_dependency "rao"

  s.add_development_dependency 'rails-dummy'
  s.add_development_dependency "sqlite3", "~> 1.4"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "pry"
  s.add_development_dependency "rb-readline"
  s.add_development_dependency "bootsnap"
end
