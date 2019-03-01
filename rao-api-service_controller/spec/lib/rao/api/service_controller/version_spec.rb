require 'rails_helper'

RSpec.describe Rao::Api::ServiceController::VERSION do
  it { expect(Rao::Api::ServiceController::VERSION).to be_a(String) }
end