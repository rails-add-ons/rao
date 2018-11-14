require 'spec_helper'
require 'rao/version'

RSpec.describe Rao::VERSION do
  it { expect(Rao::VERSION).to be_a(String) }
end