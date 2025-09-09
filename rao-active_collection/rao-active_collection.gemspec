$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "../lib/rao/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = "rao-active_collection"
  spec.version = Rao::VERSION
  spec.authors = ["BeeGood IT"]
  spec.email = ["info@beegoodit.de"]
  spec.homepage = "https://github.com/rao"
  spec.summary = "Services for Ruby on Rails."
  spec.license = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_dependency "rails", ">= 8.0"
  spec.add_dependency "rao"
end
