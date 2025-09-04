require "rails_helper"

RSpec.describe "Service REST API", type: :request do
  let(:base_path) { '/api/test_services.json' }
  let(:params) { { test_service: { name: "Jane Doe" } } }
  let(:headers) { { "Content-Type" => "application/json" } }
  
  describe "POST create" do
    before(:each) do
      post(base_path, params: params.to_json, headers: headers) 
    end

    describe "response" do
      describe "status" do
        it { expect(response.status).to eq(201) }
      end

      describe "body" do
        subject { JSON.parse(response.body) }

        it { expect(subject.keys).to match_array(%w[errors messages name]) }
      end
    end
  end
end
