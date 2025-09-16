require "rails_helper"

RSpec.describe Rao::Component::ApplicationHelper, type: :feature, js: true do
  let(:collection) { create_list(:post, 3) }
  let(:base_path) { "/posts" }

  describe "#acts_as_list_actions" do
    before do
      collection
      visit base_path
    end

    it { expect(page).to have_css('table tbody tr.post td.attribute-acts_as_list_actions') }
    
    describe "repositioning" do
      let(:reposition_button) { page.find('table tbody tr.post:first-child td.attribute-acts_as_list_actions span.acts-as-list-item') }
      let(:target_row) { page.find('table tbody tr.post:nth-child(3)') }
      let(:target_button) { target_row.find('td.attribute-acts_as_list_actions span.acts-as-list-item') }

      # Quick fix: drag to the actual draggable element, not the table row
      it "repositions the item when dragged to target button" do
        expect {
          reposition_button.drag_to(target_button)
          sleep 1 # Allow time for AJAX request to complete
        }.to change { collection.first.reload.position }.from(3).to(2)
      end
    end
  end
end