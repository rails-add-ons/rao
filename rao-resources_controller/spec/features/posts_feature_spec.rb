require 'rails_helper'

RSpec.describe "/posts", type: :feature do
  let(:factory_name) { :post }
  let(:collection) { create_list(factory_name, 3) }
  let(:resource) { create(factory_name) }
  let(:root_path) { "/posts" }
  
  describe "List" do
    let(:index_path) { root_path }

    before(:each) do
      collection
      visit(index_path)
    end
    
    describe "UI" do
      it { expect(current_path).to eq(index_path) }
      it { expect(page.body).to have_text(collection.first.title) }
    end
  end

  describe "Read" do
    let(:show_path) { "#{root_path}/#{resource.id}" }
    let(:resource) { create(factory_name) }
    
    describe "UI" do
      before(:each) do
        visit(show_path)
      end

      it { expect(current_path).to eq(show_path) }
      it { expect(page.body).to have_text(resource.title) }
    end
  end

  describe "Create" do
    let(:new_path) { "#{root_path}/new" }
    let(:submit_button) { find('input[type="submit"]') }
    
    before(:each) do
      visit(new_path)

      fill_in "Title", with: "New Post"
      fill_in "Body", with: "New Content"
    end

    describe "UI" do
      let(:success_message) { "Post was successfully created." }
      before(:each) { submit_button.click }

      it { expect(page).to have_text(success_message) }
    end

    describe "persistence changes" do
      it { expect { submit_button.click }.to change(Post, :count).by(1) }
    end
  end

  describe "Update" do
    let(:edit_path) { "#{root_path}/#{post.id}/edit" }
    let(:post) { create(factory_name) }
    let(:submit_button) { find('input[type="submit"]') }

    before(:each) do
      visit(edit_path)
      fill_in "Title", with: "Updated Post"
    end

    describe "UI" do
      let(:success_message) { "Post was successfully updated." }
      before(:each) { submit_button.click }

      it { expect(page).to have_text(success_message) }
    end

    describe "persistence changes" do
      it { expect { submit_button.click }.to change { post.reload.title }.from(post.title).to("Updated Post") }
    end
  end

  describe "Delete" do
    let(:index_path) { root_path }
    let(:delete_link) { find('a[data-turbo-method="delete"]') }

    before(:each) do
      resource
      visit(index_path)
    end
    
    describe "UI" do
      let(:success_message) { "Post was successfully destroyed." }

      before(:each) do
        delete_link.click
      end

      it { expect(page.current_path).to eq(root_path) }
      it { expect(page).to have_text(success_message) }
    end

    describe "persistence changes" do
      it { expect { delete_link.click }.to change(Post, :count).by(-1) }
    end
  end
end
