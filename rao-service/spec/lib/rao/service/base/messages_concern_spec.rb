require 'spec_helper'
require 'rao-service'
require 'pry'

class MessagesConcernService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
  end

  private

  def _perform
    say "Unnested message #1"
    say "Nesting Level #1" do
      say "Nesting Level #2" do
        say "Unnested message #2"
      end
    end
    say "Unnested message #3"
  end
end

RSpec.describe MessagesConcernService do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::MessagesConcern) }

  describe 'nested messages' do
    subject { described_class.new.perform }

    let(:expected_output) do
      [
      "[#{described_class.name}] Performing...",
      "[#{described_class.name}]   Unnested message #1",
      "[#{described_class.name}]   Nesting Level #1...",
      "[#{described_class.name}]     Nesting Level #2...",
      "[#{described_class.name}]       Unnested message #2",
      "[#{described_class.name}]     => Done",
      "[#{described_class.name}]   => Done",
      "[#{described_class.name}]   Unnested message #3",
      "[#{described_class.name}] => Done",
      ]
    end

    it { expect(subject.messages.map(&:to_s)).to eq(expected_output) }
  end
end