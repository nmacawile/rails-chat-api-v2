require "rails_helper"

RSpec.describe AuthenticateUser do
  let(:user) { create :user }
  let(:user_attributes) do
    user.slice(:first_name,
               :last_name,
               :email,
               :full_name)
  end
  let(:valid_auth_object) do
    described_class.new(user.email, user.password)
  end
  let(:invalid_auth_object) do
    described_class.new("invalid@email.com", "12345678")
  end

  describe "#call" do
    context "when valid credentials" do
      let(:auth_response) {
        valid_auth_object.call
      }

      it "returns an auth token" do
        auth_token = auth_response[:auth_token]
        expect(auth_token).not_to be_nil
      end

      it "includes user info" do
        auth_user = auth_response[:user]
        expect(auth_user).to eq user_attributes
      end
    end

    context "when invalid credentials" do
      it "raises an authentication error" do
        expect { invalid_auth_object.call }
          .to raise_error(
            ExceptionHandler::AuthenticationError,
            /Invalid credentials/
          )
      end
    end
  end
end
