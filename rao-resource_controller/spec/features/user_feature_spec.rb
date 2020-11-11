require 'rails_helper'

RSpec.describe "/user", type: :feature do
  let(:base_path) { "/user" }

  around(:each) do |example|
    Rails.application.routes.draw { resource :user }
    example.run
    Rails.application.reload_routes!
  end

  before(:each) {
    user_class = Class.new(VirtualRecord::Base) do
      def self.attribute_names
        [:id, :email]
      end
      attr_accessor *attribute_names

      validates :email, presence: true
    end
    stub_const('User', user_class)
  }

  before(:each) {
    users_controller = Class.new(Rao::ResourceController::Base) do
      def self.resource_class
        User
      end

      private

      def permitted_params
        params.require(:user).permit(:email)
      end

      def load_resource
        @resource = resource_class.first
      end
    end
    stub_const('UsersController', users_controller)
  }
  
  describe 'REST actions' do
    let(:resource_class) { User }

    describe 'show' do
      before(:each) {
        resource_class.create(email: "jane.doe@domain.local")
        visit(base_path)
      }

      it { expect(current_path).to eq(base_path) }
      it { expect(page).to have_http_status(200) }
    end

    describe 'new' do
      let(:new_path) { "#{base_path}/new" }

      before(:each) { visit(new_path) }

      it { expect(current_path).to eq(new_path) }
      it { expect(page).to have_http_status(200) }
    end

    describe 'create' do
      describe 'when valid' do
        let(:new_path) { "#{base_path}/new" }
        let(:after_create_path) { base_path }

        before(:each) {
          visit(new_path)
          fill_in "user[email]", with: "jane.doe@domain.local"
          find("input[type=submit]").click
        }

        it { pending; expect(current_path).to eq(after_create_path) }
        it { expect(page).to have_http_status(200) }
      end

      describe 'when not valid' do
        let(:new_path) { "#{base_path}/new" }
        let(:after_create_path) { base_path }

        before(:each) {
          visit(new_path)
          find("input[type=submit]").click
        }

        it { expect(current_path).to eq(base_path) }
        it { expect(page).to have_http_status(200) }
      end
    end

    describe 'edit' do
      let(:edit_path) { "#{base_path}/edit" }

      before(:each) {
        resource_class.create(email: "jane.doe@domain.local")
        visit(edit_path)
      }

      it { expect(current_path).to eq(edit_path) }
      it { expect(page).to have_http_status(200) }
    end

    describe 'update' do
      let(:edit_path) { "#{base_path}/edit" }
      before(:each) { resource_class.create(email: "jane.doe@domain.local") }

      describe 'when valid' do
        let(:after_update_path) { base_path }

        before(:each) {
          visit(edit_path)
          fill_in "user[email]", with: "jane.doe@domain.local"
          find("input[type=submit]").click
        }

        it { pending; expect(current_path).to eq(after_update_path) }
        it { expect(page).to have_http_status(200) }
      end

      describe 'when not valid' do
        before(:each) {
          visit(edit_path)
          fill_in "user[email]", with: ""
          find("input[type=submit]").click
        }

        it { expect(current_path).to eq(base_path) }
        it { expect(page).to have_http_status(200) }
      end
    end
  end
end