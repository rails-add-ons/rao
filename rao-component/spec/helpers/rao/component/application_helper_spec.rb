require "rails_helper"

RSpec.describe Rao::Component::ApplicationHelper, type: :helper do
  let(:context) { 
    view = ActionView::Base.new(ActionController::Base.view_paths)
    view.extend(described_class)
    view.assign(assigns)
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