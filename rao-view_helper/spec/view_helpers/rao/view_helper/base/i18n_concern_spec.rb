require 'rails_helper'

I18n.backend.store_translations("en",
  {
    view_helpers: {
      view_helper_with_i18n_concern: {
        foo: "Foo (en)"
      }
    }
  }
)

class ViewHelperWithI18nConcern < Rao::ViewHelper::Base
  def render_translated
    t('.foo')
  end
end

RSpec.describe ViewHelperWithI18nConcern, type: :view_helper do
  describe 'I18nConcern' do
    describe 'render_translated' do
      it { expect(rendered).to eq('Foo (en)') }
    end
  end
end