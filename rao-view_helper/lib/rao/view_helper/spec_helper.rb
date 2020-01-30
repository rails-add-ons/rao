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
    #     # spec/view_helpers/blorgh/application_view_helper_spec.rb
    #     require 'rails_helper'
    #     
    #     RSpec.describe Blorgh::ApplicationViewHelper, type: :view_helper do
    #       let(:posts) { create_list(:posts, 3) }
    #       let(:options) { {} }
    #       let(:args) { [posts, options] }
    #
    #       # if your view_helper depends on other view helpers you can register
    #       # them by calling register_view_helper the same way you'd call
    #       # view_helper in a controller.
    #       before(:each) do
    #         register_view_helper Cmor::Core::MarkupViewHelper, as: :markup_helper
    #       end
    #
    #       # if you need to set things like a request on your context you can
    #       # do it as follows:
    #       let(:request) { ActionDispatch::Request.new({ "SCRIPT_NAME" => "", "PATH_INFO" => "/de" }) }
    #
    #       before(:each) do
    #         view.request = request
    #       end
    #
    #       # this is useful when your view helper makes call like c.request.path
    #
    #       # if you need to change the default_url_options you may do so like this
    #       let(:default_url_options) { { host: 'example.org' } }
    #
    #       describe 'posts' do
    #         it { expect(rendered).to have_xpath("//div[@id='blorgh-posts']") }
    #       end
    #     end
    #
    # Make sure to use the method name as description for your describe block.
    # For example if you want to test the Blorgh::ApplicationViewHelper#render
    # method in a specific context your describe block should look like this:
    #
    #     RSpec.describe Blorgh::ApplicationViewHelper, type: :view_helper do
    #       # ...
    #
    #       # correct
    #       context 'basic usage' do
    #         describe 'render' do
    #           it { expect(rendered).to have_xpath("//div[@id='blorgh-posts']") }
    #         end
    #       end
    #
    #       # wrong
    #       describe 'render' do
    #         context 'basic usage' do
    #           it { expect(rendered).to have_xpath("//div[@id='blorgh-posts']") }
    #         end
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
        mod.let(:default_url_options) { { host: 'localhost:3000' } }
        mod.let(:rendered) {
          if respond_to?(:options)
            subject.send(method_name, options)
          elsif respond_to?(:args)
            subject.send(method_name, *args)
          else
            subject.send(method_name)
          end
        }
        mod.let(:html) { Capybara::Node::Simple.new(rendered) }

        mod.before(:each) { view.class.include Rails.application.routes.url_helpers }
        mod.before(:each) { view.class.send(:define_method, :main_app, -> { Rails.application.class.routes.url_helpers }) }
        mod.around(:each) do |example|
          original_default_url_options =  Rails.application.routes.default_url_options
          Rails.application.routes.default_url_options = default_url_options
          example.run
          Rails.application.routes.default_url_options = original_default_url_options
        end
        
        mod.subject { view_helper }

        mod.send(:define_method, :register_view_helper) do |klass, options = {}|
          method_name = options.delete(:as) || klass.name.underscore.gsub('/', '_')
          view.class.send(:define_method, method_name) do |context|
            klass.new(context)
          end
        end
      end
    end
  end
end