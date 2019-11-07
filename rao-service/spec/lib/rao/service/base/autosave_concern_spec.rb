require 'spec_helper'
require 'rao-service'

class AutosaveConcernService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
  end

  private

  def _perform
  end

  def save
    $saved = true
  end
end

RSpec.describe AutosaveConcernService do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::AutosaveConcern) }

  describe '#call!' do
    let(:attributes) { {} }
    let(:options) { {} }

    before(:each) { $saved = false }

    subject { described_class }

    it { expect(subject).to respond_to(:call!) }
    it { expect { subject.call! }.to change{ $saved }.from(false).to(true) }
  end

  describe '#autosave!' do
    subject { described_class.new }

    it { expect(subject).to respond_to(:autosave!) }
  end

  describe '#autosave?' do
    subject { described_class.new }

    it { expect(subject).to respond_to(:autosave?) }
  end
end