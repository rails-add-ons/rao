require 'rails_helper'

RSpec.describe Rao::ViewHelper::ControllerConcern do
  before(:all) do
    class DummyKlass; end
    DummyKlass.send(:include, described_class)
  end

  subject { DummyKlass }

  it { expect(subject).to respond_to(:view_helper) }
end