require 'rao/resources_controller/version'

RSpec.describe Rao::ResourcesController::VERSION do
  it { expect(Rao::ResourcesController::VERSION).to be_a(String) }
end