require_relative "../lib/rao/version"

Gem::Specification.new do |spec|
  spec.name        = "rao-resources_controller"
  spec.version     = Rao::VERSION
  spec.authors     = [ "Roberto Vasquez Angel" ]
  spec.email       = [ "rva@beegoodit.de" ]
  spec.homepage    = "https://github.com/rails-add-ons/rao-resources_controller"
  spec.summary     = "A toolkit to build resourceful controllers for Rails applications."
  spec.description = "Provides a base class and a set of modules to build resourceful controllers for Rails applications."
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

  spec.add_dependency "rails", ">= 8.0"
  spec.add_dependency "rao"
  spec.add_dependency "responders"
  spec.add_dependency "haml-rails"
  spec.add_dependency "rao-component"
  spec.add_dependency "simple_form"
end
