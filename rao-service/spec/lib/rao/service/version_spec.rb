require 'spec_helper'
require 'rao-service'

RSpec.describe Rao::Service::VERSION do
  it { expect(Rao::Service::VERSION).to be_a(String) }
end