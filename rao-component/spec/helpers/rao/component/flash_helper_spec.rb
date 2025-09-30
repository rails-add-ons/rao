require "rails_helper"

RSpec.describe Rao::Component::FlashHelper, type: :helper do
  describe "#flash_messages" do
    it { expect(helper.flash_messages).to be_a(Rao::Component::Flash) }

    describe "#render" do
      before do
        helper.flash[:notice] = "This is a notice!"
      end

      it { expect(helper.flash_messages.render).to eq("<div class='alert alert-info'>\nThis is a notice!\n</div>\n") }
    end
  end
end