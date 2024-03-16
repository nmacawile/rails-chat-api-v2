require "rails_helper"

RSpec.describe "Users API", type: :request do
  let(:user) { build :user }
  let(:user_data) do
    user.slice :first_name,
               :last_name,
               :email,
               :full_name
  end
  let(:user_attributes) do
    user.slice :first_name,
               :last_name,
               :email,
               :password
  end

  describe "POST /api/v1/signup" do
    context "when valid request" do
      before { post "/api/v1/signup", params: user_attributes }

      it "returns a 'created' status response" do
        expect(response).to have_http_status 201
      end

      it "returns an auth_token" do
        expect(json["auth_token"]).not_to be_nil
      end

      it "returns the user data" do
        expect(json["user"]).to eq user_data
      end

      it "returns a success message" do
        expect(json["message"]).to match /Account created successfully/
      end
    end

    context "when invalid request" do
      context "when the user already exists" do
        before do
          user.save
          post "/api/v1/signup", params: user_attributes
        end

        it "returns an 'unprocessable' status response" do
          expect(response).to have_http_status 422
        end

        it "returns an error message" do
          expect(json["message"]).to match /Email has already been taken/
        end
      end

      context "when the attributes are invalid" do
        before do
          post "/api/v1/signup", params: {}
        end

        it "returns an 'unprocessable' status response" do
          expect(response).to have_http_status 422
        end

        it "returns an error message" do
          expect(json["message"]).to match /Email can't be blank/
        end
      end
    end
  end
end
