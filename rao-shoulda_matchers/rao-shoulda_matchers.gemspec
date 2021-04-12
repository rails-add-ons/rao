$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "../lib/rao/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rao-shoulda_matchers"
  s.version     = Rao::VERSION
  s.authors     = ["Roberto Vasquez Angel"]
  s.email       = ["roberto@vasquez-angel.de"]
  s.homepage    = "https://github.com/rao"
  s.summary     = "Additional shoulda matchers for Ruby on Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = '>= 2.6.6'

  s.add_dependency "rao"

  s.add_development_dependency "sqlite3", "~> 1.3.6"
  s.add_development_dependency "rails-dummy"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "pry"

  # dummy app
  s.add_development_dependency "rails"
  s.add_development_dependency "bootsnap"
  s.add_development_dependency "coffee-rails", "~> 4.2"
  s.add_development_dependency "turbolinks", "~> 5"
  s.add_development_dependency "jbuilder", "~> 2.5"
  s.add_development_dependency "byebug"
  s.add_development_dependency "web-console", ">= 3.3.0"
  s.add_development_dependency "spring"
  s.add_development_dependency "spring-watcher-listen", "~> 2.0.0"
  s.add_development_dependency "puma"
  s.add_development_dependency "sass-rails", "~> 5.0"
  s.add_development_dependency "uglifier", ">= 1.3.0"
end
