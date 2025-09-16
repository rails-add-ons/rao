require "rails_helper"

RSpec.describe Rao::Component::ApplicationHelper, type: :feature do
  let(:post) { create(:post) }
  let(:base_path) { "/posts" }

  describe "#acts_as_published_actions" do
    before do
      post
      visit base_path
    end
    
    describe "publishing" do
      let(:toggle_published_button) { page.find('table tbody tr.post td.attribute-acts_as_published_actions button') }

      before { post.unpublish! }

      it { expect { toggle_published_button.click }.to change { post.reload.published? }.from(false).to(true) }
    end

    describe "unpublishing" do
      let(:toggle_unpublish_button) { page.find('table tbody tr.post td.attribute-acts_as_published_actions button') }

      it { expect { toggle_unpublish_button.click }.to change { post.reload.published? }.from(true).to(false) }
    end
  end
end