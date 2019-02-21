require "rails_helper"

RSpec.describe "Post REST API", type: :request do
  let(:base_path) { '/api/posts.json' }
  let(:params) { {} }
  let(:headers) { { "Content-Type" => "application/json" } }
  
  describe "GET list" do
    before(:each) { get(base_path, params: params, headers: headers) }
    it { expect(response).to eq("Foo") }
  end
  # it "creates a Widget and redirects to the Widget's page" do
  #   get "/widgets/new"
  #   expect(response).to render_template(:new)

  #   post "/widgets", :widget => {:name => "My Widget"}

  #   expect(response).to redirect_to(assigns(:widget))
  #   follow_redirect!

  #   expect(response).to render_template(:show)
  #   expect(response.body).to include("Widget was successfully created.")
  # end

  # it "does not render a different template" do
  #   get "/widgets/new"
  #   expect(response).to_not render_template(:show)
  # end
end