require 'spec_helper'
require 'rao/resource_controller/version'

RSpec.describe Rao::ResourceController::VERSION do
  it { expect(Rao::ResourceController::VERSION).to be_a(String) }
end