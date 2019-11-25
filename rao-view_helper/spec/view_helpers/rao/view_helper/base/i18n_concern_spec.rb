require 'rails_helper'

I18n.backend.store_translations("en",
  {
    foo: 'Unscoped Foo (en)',
    view_helpers: {
      view_helper_with_i18n_concern: {
        foo: "Scoped Foo (en)"
      }
    }
  }
)

class ViewHelperWithI18nConcern < Rao::ViewHelper::Base
  def render_scoped_translation
    t('.foo')
  end

  def render_unscoped_translation
    t('foo')
  end
end

RSpec.describe ViewHelperWithI18nConcern, type: :view_helper do
  describe 'I18nConcern' do
    describe 'render_scoped_translation' do
      it { expect(rendered).to eq('Scoped Foo (en)') }
    end

    describe 'render_unscoped_translation' do
      it { expect(rendered).to eq('Unscoped Foo (en)') }
    end
  end
end