require 'spec_helper'
require 'rao/shoulda_matchers/version'

RSpec.describe Rao::ShouldaMatchers::VERSION do
  it { expect(Rao::ShouldaMatchers::VERSION).to be_a(String) }
end