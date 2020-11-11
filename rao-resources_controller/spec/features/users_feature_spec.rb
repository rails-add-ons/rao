require 'rails_helper'

RSpec.describe "/users", type: :feature do
  let(:base_path) { "/users" }

  around(:each) do |example|
    Rails.application.routes.draw { resources :users }
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
    users_controller = Class.new(Rao::ResourcesController::Base) do
      def self.resource_class
        User
      end

      private

      def permitted_params
        params.require(:user).permit(:email)
      end
    end
    stub_const('UsersController', users_controller)
  }
  
  describe 'REST actions' do
    let(:resource_class) { User }

    describe 'index' do
      before(:each) {
        5.times do |i|
          resource_class.create(email: "jane.doe#{i}@domain.local")
        end
        visit(base_path)
      }

      it { expect(current_path).to eq(base_path) }
      it { expect(page).to have_http_status(200) }
    end

    describe 'show' do
      let(:resource) { resource_class.create(email: "jane.doe@domain.local") }
      let(:show_path) { "#{base_path}/#{resource.id}" }
      
      before(:each) {
        visit(show_path)
      }

      it { expect(current_path).to eq(show_path) }
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
        let(:resource) { resource_class.first }
        let(:after_create_path) { "#{base_path}/#{resource.id}" }

        before(:each) {
          visit(new_path)
          fill_in "user[email]", with: "jane.doe@domain.local"
          find("input[type=submit]").click
        }

        it { expect(current_path).to eq(after_create_path) }
        it { expect(page).to have_http_status(200) }
      end

      describe 'when not valid' do
        let(:new_path) { "#{base_path}/new" }

        before(:each) {
          visit(new_path)
          find("input[type=submit]").click
        }

        it { expect(current_path).to eq(base_path) }
        it { expect(page).to have_http_status(200) }
      end
    end

    describe 'edit' do
      let(:resource) { resource_class.create(email: "jane.doe@domain.local") }
      let(:edit_path) { "#{base_path}/#{resource.id}/edit" }

      before(:each) {
        visit(edit_path)
      }

      it { expect(current_path).to eq(edit_path) }
      it { expect(page).to have_http_status(200) }
    end

    describe 'update' do
      let(:resource) { resource_class.create(email: "jane.doe@domain.local") }
      let(:edit_path) { "#{base_path}/#{resource.id}/edit" }
      
      describe 'when valid' do
        let(:after_update_path) { "#{base_path}/#{resource.id}" }

        before(:each) {
          visit(edit_path)
          fill_in "user[email]", with: "john.doe@domain.local"
          find("input[type=submit]").click
        }

        it { expect(current_path).to eq(after_update_path) }
        it { expect(page).to have_http_status(200) }
      end

      describe 'when not valid' do
        let(:show_path) { "#{base_path}/#{resource.id}" }

        before(:each) {
          visit(edit_path)
          fill_in "user[email]", with: ""
          find("input[type=submit]").click
        }

        it { expect(current_path).to eq(show_path) }
        it { expect(page).to have_http_status(200) }
      end
    end
  end
end