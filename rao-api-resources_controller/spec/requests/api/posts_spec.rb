require "rails_helper"

RSpec.describe "Post REST API", type: :request do
  let(:base_path) { '/api/posts.json' }
  let(:params) { {} }
  let(:headers) { { "Content-Type" => "application/json" } }
  
  describe "GET list" do
    let(:posts) { create_list(:post, 3) }

    before(:each) do
      posts
      get(base_path, params: params, headers: headers) 
    end

    it { expect(JSON.parse(response.body)).to be_a(Array) }
    it { expect(JSON.parse(response.body).size).to eq(posts.size) }
  end
end