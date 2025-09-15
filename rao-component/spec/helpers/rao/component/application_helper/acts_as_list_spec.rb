require "rails_helper"

RSpec.describe Rao::Component::ApplicationHelper, type: :feature, js: true do
  let(:collection) { create_list(:post, 3) }
  let(:base_path) { "/posts" }

  describe "#acts_as_list_actions" do
    before do
      collection
      visit base_path
    end

    describe "repositioning" do
      it { expect(page).to have_css('table tbody tr.post td.attribute-acts_as_list_actions') }
    end
  end
end