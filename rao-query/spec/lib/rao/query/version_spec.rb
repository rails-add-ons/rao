require 'rails_helper'
require 'rao-query'

RSpec.describe Rao::Query::VERSION do
  it { expect(Rao::Query::VERSION).to be_a(String) }
end