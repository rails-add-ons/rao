require "rails_helper"

class DelayableService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
  end

  private

  def _perform
  end
end

RSpec.describe DelayableService do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::ActiveJobConcern) }

  before(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
  end

  describe '#call_later' do
    let(:attributes) { {} }
    let(:options) { {} }

    subject { described_class }

    it { expect { subject.call_later }.to have_enqueued_job(Rao::Service::Job).with(described_class.name, attributes, options) }
  end

  describe '#call_later!' do
    let(:attributes) { {} }
    let(:options) { {} }

    subject { described_class }

    it { expect { subject.call_later! }.to have_enqueued_job(Rao::Service::Job).with(described_class.name, attributes, options.merge(autosave: true)) }
  end
end