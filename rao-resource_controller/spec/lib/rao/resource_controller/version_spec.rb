require 'rails_helper'

RSpec.describe Rao::ResourceController::VERSION do
  it { expect(Rao::ResourceController::VERSION).to be_a(String) }
end