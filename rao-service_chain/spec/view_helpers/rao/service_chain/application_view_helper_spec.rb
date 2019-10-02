require 'rails_helper'
require 'pry'

RSpec.describe Rao::ServiceChain::ApplicationViewHelper, type: :view_helper do
  let(:default_url_options) { { host: 'example.org' } }

  before(:all) do
    Rails.application.routes.draw do
      resource :get_wand_services
      resource :prepare_spell_services
      resource :cast_spell_services
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

    class WizardChainWithSteps < Rao::ServiceChain::Base
      def steps
        [
          wrap(GetWandService, completed_if: ->(service_class) { true } ),
          wrap(PrepareSpellService, completed_if: ->(service_class) { true } ),
          wrap(CastSpellService, completed_if: ->(service_class) { false } ),
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
      WizardChainWithSteps
      WizardChainWithoutSteps
    ].map { |c| Object.send(:remove_const, c) }
  end

  describe 'render_progress' do
    let(:service_chain) { WizardChainWithSteps.new(actual_step: PrepareSpellService) }
    let(:args) { [service_chain, {}] }

    it { expect(html).to have_css('div.service-chain') }
  end
end