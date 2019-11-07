require 'spec_helper'
require 'rao-service'

class I18nConcernService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
  end

  private

  def _perform
  end
end

RSpec.describe I18nConcernService do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::I18nConcern) }

  describe '#t' do
    subject { described_class.new }

    it { expect(subject).to respond_to(:t) }
  end
end