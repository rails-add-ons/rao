require 'spec_helper'
require 'rao-service'
require 'pry'

class ErrorsConcernService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
  end

  attr_accessor :action

  private

  def _perform
    case action
    when :add_error
      add_error(:foo, 'bar')
    when :add_error_and_say
      add_error_and_say(:baz, 'qux')
    end
  end
end

RSpec.describe ErrorsConcernService do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::ErrorsConcern) }

  describe '#initialize_errors' do
    subject { described_class.new }

    it { expect(subject.instance_variable_get(:@errors)).to be_a(ActiveModel::Errors) }
  end

  describe '#add_error' do
    subject { described_class.call(action: :add_error) }

    it { expect(subject.instance_variable_get(:@errors).messages).to eq({ foo: ["bar"]}) }
  end

  describe '#add_error_and_say' do
    subject { described_class.call(action: :add_error_and_say) }

    it { expect(subject.messages.map(&:content)).to include("qux") }
    it { expect(subject.instance_variable_get(:@errors).messages).to eq({ baz: ["qux"]}) }
  end
end