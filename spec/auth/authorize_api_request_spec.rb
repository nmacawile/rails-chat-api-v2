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
  end
end
