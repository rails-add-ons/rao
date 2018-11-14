require 'spec_helper'
require 'rao/service/base'

RSpec.describe Rao::Service::Base do
  it { expect(described_class).to eq(Rao::Service::Base) }
end