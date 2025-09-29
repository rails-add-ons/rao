require "rails_helper"

RSpec.describe <%= class_name %>, type: :service do
  it { expect(described_class.ancestors).to include(Rao::Service::Base) }

  describe "basic usage" do
    let(:attributes) { {} }
    let(:options) { {} }

    subject { described_class.new(attributes, options) }

    describe "result" do
      it { expect(subject.perform).to be_a(Rao::Service::Result::Base) }
      it { expect(subject.perform.errors.full_messages).to match_array([]) }
    end

    describe "changes" do
      # it { expect { subject.perform }.to change { Post.count }.from(0).to(1) }
    end
  end
end
