require 'spec_helper'
require 'rao-service'

class ResultConcernService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
  end

  private

  def _perform
  end
end

RSpec.describe ResultConcernService do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::ResultConcern) }

  describe '#perform' do
    subject { described_class.new }

    it { expect(subject.perform).to be_a(Rao::Service::Result::Base) }
  end

  describe 'result' do
    subject { described_class.new.perform }

    it { expect(subject).to respond_to(:ok?) }
    it { expect(subject).to respond_to(:success?) }
    it { expect(subject).to respond_to(:failed?) }
  end
end