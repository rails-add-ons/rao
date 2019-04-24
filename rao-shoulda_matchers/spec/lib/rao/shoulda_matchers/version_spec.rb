require 'rails_helper'

RSpec.describe Rao::ShouldaMatchers::VERSION do
  it { expect(Rao::ShouldaMatchers::VERSION).to be_a(String) }
end