require 'rails_helper'

RSpec.describe Rao::ResourcesController::VERSION do
  it { expect(Rao::ResourcesController::VERSION).to be_a(String) }
end