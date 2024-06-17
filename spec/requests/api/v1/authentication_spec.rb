require "rails_helper"

RSpec.describe "Authentication API", type: :request do
  describe "POST /api/v1/auth/login" do
    let(:user) { create :user }
    let(:user_login) { user.slice(:email, :password) }

    context "when valid login" do
      before { post "/api/v1/auth/login", params: user_login }

      it "returns an 'ok' status response" do
        expect(response).to have_http_status 200
      end

      it "returns an auth_token" do
        expect(json["auth_token"]).not_to be_nil
      end

      it "returns the user data" do
        expect(json["user"]).to eq user.complete_data.as_json
      end

      it "returns an expiry" do
        expect(json["exp"]).not_to be_nil
      end
    end

    context "when invalid login" do
      before do
        post "/api/v1/auth/login", params: { email: user.email }
      end

      it "returns an 'unauthorized' status response" do
        expect(response).to have_http_status 401
      end

      it "does not return an auth_token" do
        expect(json["auth_token"]).to be_nil
      end

      it "does not return the user" do
        expect(json["user"]).to be_nil
      end

      it "returns an error message" do
        expect(json["message"]).to match /Invalid credentials/
      end
    end
  end
end
