require 'spec_helper'
require 'rao-service'

class CallbacksConcernService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
  end

  private

  def after_initialize; say  __method__; end
  def before_perform; say  __method__; end
  def _perform; say  __method__; end
  def after_perform; say  __method__; end
  def before_validation; say  __method__; end
  def after_validation; say  __method__; end
  def after_perform; say  __method__; end
end

RSpec.describe CallbacksConcernService do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::CallbacksConcern) }

  describe 'callbacks' do
    subject { described_class.new.perform }

    it { expect(subject.messages.map(&:content)).to eq(["after_initialize", "before_validation", "after_validation", "before_perform", "Performing", "_perform", "=> Done", "after_perform"]) }
  end
end