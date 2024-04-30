require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe "POST /api/v1/signup" do 
    let(:user) { build :user }
    let(:user_attributes) do
      user.slice :first_name,
                 :last_name,
                 :email,
                 :password
    end

    context "when valid request" do
      before { post "/api/v1/signup", params: user_attributes }

      it "returns a 'created' status response" do
        expect(response).to have_http_status 201
      end

      it "returns an auth_token" do
        expect(json["auth_token"]).not_to be_nil
      end

      it "returns the user data" do
        expect(json["user"]["id"]).not_to be_nil
        expect(json["user"]["email"]).to eq user.email
        expect(json["user"]["first_name"]).to eq user.first_name
        expect(json["user"]["last_name"]).to eq user.last_name
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

  describe "GET /api/v1/users" do
    let(:user) { create :user }
    let(:users) { create_list :user, 10 }
    let(:users_data) { users.map { |u| u.data } }
    let(:headers) { { Authorization: "Bearer #{generate_token(user.id)}"} }

    before { get "/api/v1/users", headers: headers }

    it "returns a list of users" do
      expect(json).not_to include user.data
    end
  end
end
