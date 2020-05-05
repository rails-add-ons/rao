require 'rails_helper'

RSpec.describe Rao::ServiceChain::Aasm::Base do
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

    class WizardChainWithSteps < Rao::ServiceChain::Aasm::Base
      # def steps
      #   [
      #     wrap(GetWandService, completed_if: ->(service_class) { true } ),
      #     wrap(PrepareSpellService, completed_if: ->(service_class) { true } ),
      #     wrap(CastSpellService, completed_if: ->(service_class) { false } ),
      #   ]
      # end
      aasm do
        state :started, initial: true
        state :get_wand_service, completed_if: ->(service_class) { true }
        state :prepare_spell_service, completed_if: ->(service_class) { true }
        state :cast_spell_service, completed_if: ->(service_class) { false }
        state :finished

        event :previous do
          transitions from: :finished, to: :cast_spell_service
          transitions from: :cast_spell_service, to: :prepare_spell_service
          transitions from: :prepare_spell_service, to: :get_wand_service
          transitions from: :get_wand_service, to: :started
        end

        event :next do
          transitions from: :started , to: :get_wand_service
          transitions from: :get_wand_service , to: :prepare_spell_service
          transitions from: :prepare_spell_service , to: :cast_spell_service
          transitions from: :cast_spell_service , to: :finished
        end
      end
    end

    class WizardChainWithoutSteps < Rao::ServiceChain::Aasm::Base
      aasm do
        state :started, initial: true
        state :finished

        event :previous do
        end

        event :next do
        end
      end
    end
  end

  after(:all) do
    %w[
      GetWandService
      PrepareSpellService
      CastSpellService
      WizardChainWithSteps
      WizardChainWithoutSteps
    ].map { |c| Object.send(:remove_const, c) }
  end

  it { expect(described_class).to eq(Rao::ServiceChain::Aasm::Base) }

  describe '#actual_step' do
  	describe 'when none given' do
  	  subject { WizardChainWithoutSteps.new }

  	  it { expect(subject.actual_step).to be_nil }
  	end

  	describe 'when steps given' do
  		let(:actual_step) { PrepareSpellService }
  	  subject { WizardChainWithSteps.new(actual_step: actual_step) }

  	  it { expect(subject.actual_step).to be_a(Rao::ServiceChain::Step::Base) }
  	  it { expect(subject.actual_step.service).to eq(actual_step) }
  	end
  end

  describe '#previous_step' do
  	describe 'when no steps given' do
  	  subject { WizardChainWithoutSteps.new }

  	  it { expect(subject.previous_step).to be_nil }
  	end

  	describe 'when no actual step given' do
  	  subject { WizardChainWithSteps.new }

  	  it { expect(subject.previous_step).to be_nil }
  	end

  	describe 'when steps and actual step given' do
  		let(:actual_step) { PrepareSpellService }
  	  subject { WizardChainWithSteps.new(actual_step: actual_step) }

  	  it { expect(subject.previous_step.service).to eq(GetWandService) }
  	end
  end

  describe '#next_step' do
  	describe 'when no steps given' do
  	  subject { WizardChainWithoutSteps.new }

  	  it { expect(subject.next_step).to be_nil }
  	end

  	describe 'when no actual step given' do
  	  subject { WizardChainWithSteps.new }

      # This is a different behaviour than in simple service chains
      # without aasm.
      # When no actual step is given the actual step is nil. But the current state
      # is :started. So the next step is the step that corresponds to the next state.
      #
  	  it { expect(subject.next_step.service).to eq(GetWandService) }
  	end

  	describe 'when steps and actual step given' do
  		let(:actual_step) { PrepareSpellService }
  	  subject { WizardChainWithSteps.new(actual_step: actual_step) }

  	  it { expect(subject.next_step.service).to eq(CastSpellService) }
  	end
  end

  describe '#steps' do
  	subject { WizardChainWithSteps.new }
  	
  	it { expect(subject.steps).to be_a(Array) }
  	it { expect(subject.steps.map(&:service)).to eq([GetWandService, PrepareSpellService, CastSpellService]) }
  end

  describe '#step_count' do
  	subject { WizardChainWithSteps.new }
  	
  	it { expect(subject.step_count).to eq(3) }
  end

  describe '#pending_steps' do
  	subject { WizardChainWithSteps.new }

  	it { expect(subject.pending_steps.map(&:service)).to eq([CastSpellService]) }
  end

  describe '#completed_steps' do
  	subject { WizardChainWithSteps.new }

  	it { expect(subject.completed_steps.map(&:service)).to eq([GetWandService, PrepareSpellService]) }
  end

  describe '#previous_steps' do
    describe 'when no steps given' do
      subject { WizardChainWithoutSteps.new }

      it { expect(subject.previous_steps).to eq([]) }
    end

    describe 'when no actual step given' do
      subject { WizardChainWithSteps.new }

      it { expect(subject.previous_steps).to eq([]) }
    end

    describe 'when steps and actual step given' do
      let(:actual_step) { PrepareSpellService }
      subject { WizardChainWithSteps.new(actual_step: actual_step) }

      it { expect(subject.previous_steps.map(&:service)).to eq([GetWandService]) }
    end
  end

  describe '#next_steps' do
    describe 'when no steps given' do
      subject { WizardChainWithoutSteps.new }

      it { expect(subject.previous_steps).to eq([]) }
    end

    describe 'when no actual step given' do
      subject { WizardChainWithSteps.new }

      it { expect(subject.previous_steps).to eq([]) }
    end

    describe 'when steps and actual step given' do
      let(:actual_step) { PrepareSpellService }
      subject { WizardChainWithSteps.new(actual_step: actual_step) }

      it { expect(subject.next_steps.map(&:service)).to eq([CastSpellService]) }
    end
  end

  describe '#before_actual?' do
    describe 'when no steps given' do
      subject { WizardChainWithoutSteps.new }

      it { expect(subject.before_actual?(GetWandService)).to eq(false) }
    end

    describe 'when no actual step given' do
      subject { WizardChainWithSteps.new }

      it { expect(subject.before_actual?(GetWandService)).to eq(false) }
    end

    describe 'when steps and actual step given' do
      let(:chain) { WizardChainWithSteps.new(actual_step: actual_step) }
      let(:actual_step) { PrepareSpellService }
      let(:previous_step) { GetWandService }
      subject { chain }

      it { expect(subject.before_actual?(GetWandService)).to eq(true) }
    end
  end

  describe '#after_actual?' do
    describe 'when no steps given' do
      subject { WizardChainWithoutSteps.new }

      it { expect(subject.before_actual?(CastSpellService)).to eq(false) }
    end

    describe 'when no actual step given' do
      subject { WizardChainWithSteps.new }

      it { expect(subject.before_actual?(CastSpellService)).to eq(false) }
    end

    describe 'when steps and actual step given' do
      let(:chain) { WizardChainWithSteps.new(actual_step: actual_step) }
      let(:actual_step) { PrepareSpellService }
      let(:previous_step) { GetWandService }
      subject { chain }

      it { expect(subject.after_actual?(CastSpellService)).to eq(true) }
    end
  end
end
