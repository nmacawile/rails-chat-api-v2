require 'rails_helper'

RSpec.describe "Visibility API", type: :request do
  describe "PATCH /api/v1/visibility" do
    let(:user) { create :user }
    let(:headers) { { "Authorization" => generate_token(user.id) } }

    before do
      patch "/api/v1/visibility", headers: headers, params: { visibility: visibility }
      user.reload
    end

    context "when visibility parameter is set to false" do
      let(:visibility) { false }

      it "changes the visibility status to false" do
        expect(user.visibility).to be(false)
      end

      it "returns an 'ok' response status" do
        expect(response).to have_http_status 200
      end

      it "returns the user data" do
        expect(json["user"]).to eq user.complete_data.as_json
      end
    end
    
    context "when visibility parameter is set to true" do
      let(:user) { create :user, visibility: false }
      let(:visibility) { true }

      it "changes the visibility status to true" do
        expect(user.visibility).to be(true)
      end

      it "returns an 'ok' response status" do
        expect(response).to have_http_status 200
      end

      it "returns the user data" do
        expect(json["user"]).to eq user.complete_data.as_json
      end
    end
  end
end
