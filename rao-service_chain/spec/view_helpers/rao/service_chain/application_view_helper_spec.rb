require 'rails_helper'
require 'pry'

RSpec.describe Rao::ServiceChain::ApplicationViewHelper, type: :view_helper do
  let(:default_url_options) { { host: 'example.org' } }

  before(:all) do
    Rails.application.routes.draw do
      resource :get_wand_services
      resource :prepare_spell_services
      resource :cast_spell_services
      resource :recover_mana_services
    end

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

    class RecoverManaService < Rao::Service::Base
      class Result < Rao::Service::Result::Base
      end
    end

    class WizardChainWithSteps < Rao::ServiceChain::Base
      def steps
        [
          wrap(GetWandService, completed_if: ->(service_class) { true } ),
          wrap(PrepareSpellService, completed_if: ->(service_class) { true } ),
          wrap(CastSpellService, completed_if: ->(service_class) { true } ),
          wrap(RecoverManaService, completed_if: ->(service_class) { false } )
        ]
      end
    end

    class WizardChainWithoutSteps < Rao::ServiceChain::Base
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
      RecoverManaService
      WizardChainWithSteps
      WizardChainWithoutSteps
    ].map { |c| Object.send(:remove_const, c) }
  end

  context 'basic usage' do
    describe 'render_progress' do
      let(:service_chain) { WizardChainWithSteps.new(actual_step: PrepareSpellService) }
      let(:args) { [service_chain, {}] }
  
      it { expect(html).to have_css('div.service-chain') }
    end
  end

  context 'render next steps according to their status' do
    describe 'render_progress' do
      let(:service_chain) { WizardChainWithSteps.new(actual_step: PrepareSpellService) }
      let(:chain_options) { { next_steps: { render_as_pending: false, link: false } } }
      let(:args) { [service_chain, chain_options] }
        
      it 'renders class' do
        expect(html).to have_xpath('//*[@id="step1"]/span[contains(@class,"render-completed")]')
        expect(html).to have_xpath('//*[@id="step3"]/span[contains(@class,"render-completed")]')
        expect(html).to have_xpath('//*[@id="step4"]/span[contains(@class,"render-pending")]')
      end
    end
  end

  context 'render next steps as pending' do
    describe 'render_progress' do
      let(:service_chain) { WizardChainWithSteps.new(actual_step: PrepareSpellService) }
      let(:chain_options) { { next_steps: { render_as_pending: true, link: false } } }
      let(:args) { [service_chain, chain_options] }

      it 'renders class' do
        expect(html).to have_xpath('//*[@id="step1"]/span[contains(@class,"render-completed")]')
        expect(html).to have_xpath('//*[@id="step3"]/span[contains(@class,"render-pending")]')
        expect(html).to have_xpath('//*[@id="step4"]/span[contains(@class,"render-pending")]')
      end
    end
  end

  context 'render links' do
    describe 'render_progress' do
      let(:service_chain) { WizardChainWithSteps.new(actual_step: PrepareSpellService) }
      let(:chain_options) { { next_steps: { render_as_pending: false, link: true } } }
      let(:args) { [service_chain, chain_options] }

      it 'renders link' do
        expect(html).to have_xpath('//*[@id="step3"]/span[2]/a[contains(@href,"cast_spell_services/new")]')
        expect(html).to have_xpath('//*[@id="step4"]/span[2]/a[contains(@href,"recover_mana_services/new")]')
      end
    end
  end
end