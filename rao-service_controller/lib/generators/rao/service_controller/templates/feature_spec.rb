require "rails_helper"

RSpec.describe "<%= base_path %>", type: :feature do
  let(:base_path) { "<%= base_path %>" }

  describe "basic usage" do
    let(:new_path) { "#{base_path}/new" }

    before(:each) do
      visit(new_path)
    end

    describe "UI" do
      let(:submit_button) { find('[type="submit"]') }
      
      before do
        visit new_path

        # fill_in the needed form inputs via capybara here

        submit_button.click
      end

      it { expect(current_path).to eq(new_path) }
      it { expect(page.body).to have_text("#{<%= service_class %>.model_name.human} was executed.") }
    end
  end
end