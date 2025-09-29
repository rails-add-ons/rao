require "rails_helper"

RSpec.describe Rao::Component::Flash do
  let(:controller) { ActionController::Base.new }
  let(:flash_hash) { ActionDispatch::Flash::FlashHash.new }
  let(:view) do
    lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
    view = ActionView::Base.new(lookup_context, {}, controller)
    
    # Define the required method for ActionView::Base
    view.define_singleton_method :compiled_method_container do
      self.class
    end
    
    view
  end
  
  before do
    allow(controller).to receive(:flash).and_return(flash_hash)
    # Make the view have access to the flash through the controller
    allow(view).to receive(:flash).and_return(flash_hash)
  end
  
  subject { described_class.new(view) }  # Pass view instead of controller
  it { expect(subject).to be_a(Rao::Component::Base) }

  describe "#render" do
    describe "when there is no flash" do
      let(:flash_hash) { ActionDispatch::Flash::FlashHash.new }
      
      it "returns empty string" do
        result = described_class.new(view).render
        expect(result).to eq("")
      end
    end

    describe "when there is a flash" do
      let(:flash_hash) { ActionDispatch::Flash::FlashHash.new(notice: "Flash message") }
      
      it "renders flash messages with correct CSS classes" do
        result = described_class.new(view).render
        parsed = Capybara::Node::Simple.new(result)

        expect(parsed).to have_css("div.alert.alert-info")
        expect(parsed).to have_content("Flash message")
      end
    end
  end
end
