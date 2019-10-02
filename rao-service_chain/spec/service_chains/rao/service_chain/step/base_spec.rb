require 'rails_helper'

RSpec.describe Rao::ServiceChain::Step::Base do
	before(:all) do
		class GetWandService < Rao::Service::Base
			class Result < Rao::Service::Result::Base
			end
		end

		class PrepareSpellService < Rao::Service::Base
			class Result < Rao::Service::Result::Base
			end
		end

		class CastSpellService < Rao::Service::Base
			class Result < Rao::Service::Result::Base
			end
		end

		class WizardChainWithSteps < Rao::ServiceChain::Base
			def steps
				[
					wrap(GetWandService),
					wrap(PrepareSpellService),
					wrap(CastSpellService),
				]
			end
		end

		class WizardChain < Rao::ServiceChain::Base
			def steps
				[]
			end
		end
	end

	after(:all) do
		%w[
			GetWandService
			PrepareSpellService
			CastSpellService
			WizardChainWithSteps
			WizardChain
    ].map { |c| Object.send(:remove_const, c) }
  end

  it { expect(described_class).to eq(Rao::ServiceChain::Step::Base) }

  describe '#service' do
  	let(:service) { CastSpellService }
  	subject { described_class.new(service: service) }

  	it { expect(subject.service).to eq(service) }
  end

	describe '#service_name' do
		let(:service) { CastSpellService }
		subject { described_class.new(service: service) }

		it { expect(subject.service_name).to eq(service.name) }
	end

	describe '#label' do
		let(:service) { CastSpellService }
		subject { described_class.new(service: service) }

		it { expect(subject.label).to eq(service.model_name.human) }
	end

	describe '#chain' do
		let(:chain) { WizardChain.new }
		subject { described_class.new(chain: chain) }

		it { expect(subject.chain).to eq(chain) }
	end

  describe '#completed?' do
		let(:service) { CastSpellService }
		let(:completed_if_proc) { ->(service) { true } }
		subject { described_class.new(service: service, completed_if: completed_if_proc) }

		it { expect(subject.completed?).to eq(true) }
  end

  describe '#pending?' do
		let(:service) { CastSpellService }
		let(:completed_if_proc) { ->(service) { true } }
		subject { described_class.new(service: service, completed_if: completed_if_proc) }

		it { expect(subject.pending?).to eq(false) }
  end

  describe '#completion_status' do
  	describe 'when completed' do
			let(:service) { CastSpellService }
			let(:completed_if_proc) { ->(service) { true } }
			subject { described_class.new(service: service, completed_if: completed_if_proc) }

			it { expect(subject.completion_status).to eq(:completed) }
		end

  	describe 'when pending' do
			let(:service) { CastSpellService }
			let(:completed_if_proc) { ->(service) { false } }
			subject { described_class.new(service: service, completed_if: completed_if_proc) }

			it { expect(subject.completion_status).to eq(:pending) }
		end
  end

  describe '#actual?' do
  	let(:actual_step) { CastSpellService }
		let(:chain) { WizardChainWithSteps.new(actual_step: actual_step) }
		let(:service) { CastSpellService }
		let(:completed_if_proc) { ->(service) { true } }
		subject { described_class.new(chain: chain, service: service) }

		it { expect(subject.actual?).to eq(true) }
  end

end