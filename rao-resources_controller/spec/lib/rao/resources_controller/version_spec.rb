require "rails_helper"
require "rao-resources_controller"

RSpec.describe Rao::ResourcesController::VERSION do
  it { expect(Rao::ResourcesController::VERSION).to be_a(String) }
end
