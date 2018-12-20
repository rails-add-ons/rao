require 'spec_helper'
require 'rao/view_helper/version'

RSpec.describe Rao::ViewHelper::VERSION do
  it { expect(Rao::ViewHelper::VERSION).to be_a(String) }
end