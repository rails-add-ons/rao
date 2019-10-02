require 'rails_helper'

RSpec.describe Rao::Service::VERSION do
  it { expect(Rao::Service::VERSION).to be_a(String) }
end