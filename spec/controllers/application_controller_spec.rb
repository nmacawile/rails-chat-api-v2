require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create :user }

  describe "#authorize_request" do
    before do
      allow(request).to receive(:headers).and_return(headers)
    end

    context "when auth token is passed" do
      let(:headers) do
        { "Authorization" => "Bearer #{generate_token(user.id)}"}
      end

      it "sets the current user" do
        expect(subject.instance_eval { authorize_request }).to eq user
      end
    end

    context "when auth token is missing" do
      let(:headers) do
        { "Authorization" => nil }
      end

      it "raises MissingToken error" do
        expect { subject.instance_eval { authorize_request } }.to(
          raise_error(ExceptionHandler::MissingToken, /Missing token/))
      end
    end
  end
end
