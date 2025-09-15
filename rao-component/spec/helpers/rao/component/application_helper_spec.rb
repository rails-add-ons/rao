require "rails_helper"

RSpec.describe Rao::Component::ApplicationHelper, type: :feature do
  let(:base_path) { "/posts" }
  
  describe "#collection_table" do
    describe "for an array of active record objects" do
      let(:posts) { create_list(:post, 3) }

      before do
        posts
        visit base_path
      end

      it { expect(page).to have_css('table') }
      it { expect(page).to have_css('table.table') }
      it { expect(page).to have_css('table.collection-table') }
      it { expect(page).to have_css('table.posts') }
      it { expect(page).to have_css('table thead') }
      it { expect(page).to have_css('table tbody') }
      it { expect(page).to have_css('table tbody tr.post') }
      it { expect(page).to have_css('table tbody tr.post td.attribute-id') }
      it { expect(page).to have_css('table tbody tr.post td.attribute-title') }
      it { expect(page).to have_css('table tbody tr.post td.attribute-body') }
      it { expect(page).to have_css('table tbody tr.post td.attribute-published_at') }
      it { expect(page).to have_css('table tbody tr.post td.attribute-position') }
    end

    describe "for an array of OpenStruct objects" do
      let(:index_path) { "/open_structs/index" }

      before do
        visit index_path
      end

      it { expect(page).to have_css('table') }
      it { expect(page).to have_css('table.table') }
      it { expect(page).to have_css('table.collection-table') }
      it { expect(page).to have_css('table.open_structs') }
      it { expect(page).to have_css('table thead') }
      it { expect(page).to have_css('table tbody') }
      it { expect(page).to have_css('table tbody tr.open_struct') }
    end

    describe "td html options" do
      let(:options_path) { "/options/index" }

      before do
        visit options_path
      end

      describe "with hash options" do
        it { expect(page).to have_css('#td-hash-options table tbody tr.open_struct td.highlight-name') }
        it { expect(page).to have_css('#td-hash-options table tbody tr.open_struct td.status-cell[data-status="custom"]') }
      end

      describe "with proc options" do
        it { expect(page).to have_css('#td-proc-options table tbody tr.open_struct td.special-name') }
        it { expect(page).to have_css('#td-proc-options table tbody tr.open_struct td.active-status') }
        it { expect(page).to have_css('#td-proc-options table tbody tr.open_struct td.inactive-status') }
      end
    end

    describe "tr html options" do
      let(:options_path) { "/options/index" }

      before do
        visit options_path
      end

      describe "with hash options" do
        it { expect(page).to have_css('#tr-hash-options table tbody tr.custom-row') }
      end

      describe "with proc options" do
        it { expect(page).to have_css('#tr-proc-options table tbody tr.active-row') }
        it { expect(page).to have_css('#tr-proc-options table tbody tr.inactive-row') }
      end

      describe "with proc options using index" do
        it { expect(page).to have_css('table tbody tr.first-row') }
      end
    end
  end

  describe "#resource_table" do
    describe "for an active record object" do
      let(:post) { create(:post) }
      let(:show_path) { "/posts/#{post.id}" }

      before do
        post
        visit show_path
      end

      it { expect(page).to have_css('table') }
      it { expect(page).to have_css('table.table') }
      it { expect(page).to have_css('table.resource-table') }
      it { expect(page).to have_css('table.post') }
      it { expect(page).to have_css('table tbody') }
      it { expect(page).to have_css('table tbody tr.post') }
      it { expect(page).to have_css('table tbody tr.post.attribute-id') }
      it { expect(page).to have_css('table tbody tr.post.attribute-title') }
      it { expect(page).to have_css('table tbody tr.post.attribute-body') }
      it { expect(page).to have_css('table tbody tr.post.attribute-published_at') }
      it { expect(page).to have_css('table tbody tr.post.attribute-position') }
    end

    describe "for an open struct object" do
      let(:show_path) { "/open_structs/show" }

      before do
        visit show_path
      end

      it { expect(page).to have_css('table') }
      it { expect(page).to have_css('table.table') }
      it { expect(page).to have_css('table.resource-table') }
      it { expect(page).to have_css('table.open_struct') }
      it { expect(page).to have_css('table tbody') }
      it { expect(page).to have_css('table tbody tr.open_struct') }
      it { expect(page).to have_css('table tbody tr.open_struct.attribute-id') }
      it { expect(page).to have_css('table tbody tr.open_struct.attribute-name') }
    end
  end
end