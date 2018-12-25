require 'rao/view_helper'

module Rao
  module ViewHelper
    # Setup:
    #
    #     # spec/support/rao-view_helper.rb:
    #     require 'rao/view_helper/spec_helper'
    #
    #     RSpec.configure do |c|
    #       c.include Rao::ViewHelper::SpecHelper, type: :view_helper
    #     end
    #
    # Usage:
    #
    #     # spec/view_helper/blorgh/application_view_helper_spec.rb
    #     require 'rails_helper'
    #     
    #     RSpec.describe Blorgh::ApplicationViewHelper, type: :view_helper do
    #       describe 'posts' do
    #         it { expect(rendered).to have_xpath("//div[@id='blorgh-posts']") }
    #       end
    #     end
    #
    module SpecHelper
      def self.included(mod)
        mod.let(:view_paths) { ActionController::Base.view_paths }
        mod.let(:assigns) { {} }
        mod.let(:view) { ActionView::Base.new(view_paths, assigns) }
        mod.let(:view_helper) { described_class.new(view) }
        mod.let(:method_name) { |e| e.metadata[:example_group][:description].to_sym }
        mod.let(:rendered) {
          if respond_to?(:options)
            Capybara::Node::Simple.new(subject.send(method_name, options))
          else
            Capybara::Node::Simple.new(subject.send(method_name))
          end
        }
        
        mod.subject { view_helper }
      end
    end
  end
end