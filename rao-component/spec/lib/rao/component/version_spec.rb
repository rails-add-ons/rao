require 'spec_helper'
require 'rao/component/version'

RSpec.describe Rao::Component::VERSION do
  it { expect(Rao::Component::VERSION).to be_a(String) }
end