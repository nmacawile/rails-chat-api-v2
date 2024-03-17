require "rails_helper"

RSpec.describe AuthorizeApiRequest do
  let(:user) { create :user }
  let(:headers) do
    { "Authorization" => "Bearer #{generate_token(user.id)}" }
  end
  subject {
    described_class.new(headers)
  }
  
  describe "#call" do
    context "when valid credentials" do
      it "returns the user data" do
        decoded_user_data = subject.call[:user]
        expect(decoded_user_data).to eq user.data
      end
    end

    context "when invalid credentials" do      
      context "when missing credentials" do
        let(:headers) { {} }

        it "raises a MissingToken error" do
          expect { subject.call }.to(
            raise_error ExceptionHandler::MissingToken,
                       /Missing token/)
        end
      end

      context "when fake token" do
        let(:headers) { { "Authorization" => "Bearer INVALIDTOKEN" } }

        it "raises an InvalidToken error" do
          expect { subject.call }.to(
            raise_error ExceptionHandler::InvalidToken,
                        /Not enough or too many segments/)
        end
      end
      
      context "when expired token" do
        let(:headers) do
          { "Authorization" => "Bearer #{generate_expired_token(user.id)}" }
        end

        it "raises an InvalidToken error" do
          expect { subject.call }.to(
            raise_error ExceptionHandler::InvalidToken,
                        /Signature has expired/)
        end
      end
    end
  end
end
