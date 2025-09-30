require "rails_helper"

RSpec.describe "/user", type: :feature do
  let(:factory_name) { :user }
  let(:resource) { create(factory_name) }
  let(:root_path) { "/user" }

  describe "Read" do
    let(:show_path) { root_path }

    describe "UI" do
      before(:each) do
        resource
        visit(show_path)
      end

      it { expect(current_path).to eq(show_path) }
      it { expect(page.body).to have_text(resource.name) }
    end
  end

  describe "Create" do
    let(:new_path) { "#{root_path}/new" }
    let(:submit_button) { find('input[type="submit"]') }

    before(:each) do
      visit(new_path)

      fill_in "Name", with: "New User"
      fill_in "Email", with: "new@example.com"
    end

    describe "UI" do
      let(:success_message) { "User was successfully created." }
      before(:each) { submit_button.click }

      it { expect(page).to have_text(success_message) }
    end

    describe "persistence changes" do
      it { expect { submit_button.click }.to change(User, :count).by(1) }
    end
  end

  describe "Update" do
    let(:edit_path) { "#{root_path}/edit" }
    let(:user) { create(factory_name) }
    let(:submit_button) { find('input[type="submit"]') }

    before(:each) do
      user
      visit(edit_path)
      fill_in "Name", with: "Updated User"
    end

    describe "UI" do
      let(:success_message) { "User was successfully updated." }
      before(:each) { submit_button.click }

      it { expect(page).to have_text(success_message) }
    end

    describe "persistence changes" do
      it { expect { submit_button.click }.to change { user.reload.name }.from(user.name).to("Updated User") }
    end
  end

  describe "Delete" do
    let(:show_path) { root_path }
    let(:delete_link) { find('a[data-turbo-method="delete"]') }

    before(:each) do
      resource
      visit(show_path)
    end

    describe "UI" do
      let(:success_message) { "User was successfully destroyed." }

      before(:each) do
        delete_link.click
      end

      it { expect(page.current_path).to eq("/") }
      it { expect(page).to have_text(success_message) }
    end

    describe "persistence changes" do
      it { expect { delete_link.click }.to change(User, :count).from(1).to(0) }
    end
  end
end
