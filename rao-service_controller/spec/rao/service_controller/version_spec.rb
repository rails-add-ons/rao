require 'rails_helper'

RSpec.describe Rao::ServiceController::VERSION do
  it { expect(Rao::ServiceController::VERSION).to be_a(String) }
end