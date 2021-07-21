require "rails_helper"

RSpec.describe Rao::Component::ApplicationHelper, type: :helper do
  let(:context) { 
    # https://stackoverflow.com/questions/59773680/deprecation-warning-actionviewbase-instances-should-be-constructed-with-a-loo
    # https://github.com/mileszs/wicked_pdf/issues/878
    
    lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
    view = ActionView::Base.new(lookup_context, assigns, ActionController::Base.new)
    
    # view = ActionView::Base
    #          .with_view_paths(ActionController::Base.view_paths, assigns)
    # view.extend(described_class)
    
    view.define_singleton_method :compiled_method_container do
      self.class
    end
    
    view.class_eval do
      include Rao::Component::ApplicationHelper
    end
    
    view
  }

  let(:rendered) { Haml::Engine.new(haml).render(context) }

  subject {
    Capybara::Node::Simple.new(rendered)
  }
  
  describe "#collection_table" do
    describe "for an empty collection" do
      let(:assigns) { { collection: [] } }
      let(:haml) {
        <<~EOF
        = collection_table(collection: @collection) do |t|
          = t.column :id
          = t.column :name
          EOF
      }
      
      it { expect(rendered).to be_a(String) }
    end

    describe "for an array of hashes" do
      let(:assigns) {
        {
          collection:
          [
            OpenStruct.new({ id: '1', name: 'Foo' }),
            OpenStruct.new({ id: '2', name: 'Bar' })
          ]
        }
      }
      let(:haml) {
        <<~EOF
        = collection_table(collection: @collection) do |t|
          = t.column :id
          = t.column :name
          EOF
      }
      
      it { expect(rendered).to be_a(String) }
      it { expect(subject).to have_css('table') }
      it { expect(subject).to have_css('table.table') }
      it { expect(subject).to have_css('table.collection-table') }
      it { expect(subject).to have_css('table.open_structs') }
      it { within('table') { expect(subject).to have_css('thead') } }
      it { within('table') { expect(subject).to have_css('tbody') } }
      it { within('table tbody') { expect(subject).to have_css('tr.open_struct') } }
      it { within('table tbody tr.open_struct') { expect(subject).to have_css('td.attribute-id') } }
      it { within('table tbody tr.open_struct') { expect(subject).to have_css('td.attribute-name') } }
    end

    describe 'td html options' do
      let(:assigns) {
        {
          collection:
          [
            OpenStruct.new({ id: '1', name: 'Foo' }),
            OpenStruct.new({ id: '2', name: 'Bar' })
          ]
        }
      }

      describe 'with a hash' do
        let(:haml) {
          <<~EOF
          = collection_table(collection: @collection) do |t|
            = t.column :id
            = t.column :name, td_html: { class: "foo" }
            EOF
        }
        it { expect(rendered).to be_a(String) }
        it { within('table tbody tr.open_struct') { expect(subject).to have_css('td.foo') } }
      end

      describe 'with a proc' do
        let(:haml) {
          <<~EOF
          = collection_table(collection: @collection) do |t|
            = t.column :id
            = t.column :name, td_html: ->(r) { r.id == "2" ? { class: "foo" } : {} }
            EOF
        }
        
        it { expect(rendered).to be_a(String) }
        it { within('table tbody tr.open_struct') { expect(subject).to have_css('td.foo') } }
      end
    end

    describe 'tr html options' do
      let(:assigns) {
        {
          collection:
          [
            OpenStruct.new({ id: '1', name: 'Foo' }),
            OpenStruct.new({ id: '2', name: 'Bar' })
          ]
        }
      }

      describe 'with a hash' do
        let(:haml) {
          <<~EOF
          = collection_table(collection: @collection) do |t|
            - t.tr_html = { class: "foo" }
            = t.column :id
            = t.column :name
            EOF
        }

        it { expect(rendered).to be_a(String) }
        it { within('table tbody') { expect(subject).to have_css('tr.foo') } }
      end

      describe 'with a hash' do
        let(:haml) {
          <<~EOF
          = collection_table(collection: @collection) do |t|
            - t.tr_html = ->(r, i) { r.id == "1" ? { class: "foo" } : nil }
            = t.column :id
            = t.column :name
            EOF
        }

        it { expect(rendered).to be_a(String) }
        it { within('table tbody') { expect(subject).to have_css('tr.foo') } }
      end
    end
  end

  describe "#resource_table" do
    describe "basic usage" do
      let(:assigns) { { resource: OpenStruct.new(id: 1, name: 'John Doe') } }
      let(:haml) {
        <<~EOF
        = resource_table(resource: @resource) do |t|
          = t.row :id
          = t.row :name
          EOF
      }
      
      it { expect(rendered).to be_a(String) }
      it { expect(subject).to have_css('table') }
      it { expect(subject).to have_css('table.table') }
      it { expect(subject).to have_css('table.resource-table') }
      it { expect(subject).to have_css('table.open_struct') }
      it { within('table') { expect(subject).to have_css('thead') } }
      it { within('table') { expect(subject).to have_css('tbody') } }
      it { within('table tbody') { expect(subject).to have_css('tr.open_struct') } }
      it { within('table tbody tr.open_struct') { expect(subject).to have_css('td.attribute-id') } }
      it { within('table tbody tr.open_struct') { expect(subject).to have_css('td.attribute-name') } }
    end
  end
end