require 'rails_helper'

RSpec.describe "Messages API", type: :request do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:eavesdropper) { create :user }
  let(:chat) { create :chat, users: [user, other_user] }
  let(:headers) { { "Authorization" => generate_token(user.id) } }
  let(:params) { {} }
  let!(:older_messages) do
    create_list :message, 4, messageable: chat, user: user
  end
  let!(:newer_messages) do
    create_list :message, 20, messageable: chat, user: other_user
  end

  let(:newer_messages_hash) do
    transform_messages(newer_messages)
  end

  let(:older_messages_hash) do
    transform_messages(older_messages)

  end

  describe "GET /api/v1/:chat_id/messages" do
    before do
      get("/api/v1/chats/#{chat.id}/messages", 
           params: params,
           headers: headers)
    end

    context "without query" do
      it "returns an 'ok' response status" do
        expect(response).to have_http_status 200
      end
      
      it "returns the latest 20 messages" do
        expect(json).to match_array newer_messages_hash
      end
    end

    context "with query" do
      let(:params) { { before: newer_messages.first.id } }

      it "returns an 'ok' response status" do
        expect(response).to have_http_status 200
      end

      it "returns the older messages" do
        expect(json.size).to eq 4
      end
      
      it "returns the older messages" do
        expect(json).to match_array older_messages_hash
      end
    end

    context "unauthorized access" do
      let(:headers) { { "Authorization" => generate_token(eavesdropper.id) } }

      it "returns a 'forbidden' response status" do
        expect(response).to have_http_status 403
      end

      it "returns an error message" do
        expect(json["message"]).to match /Access denied/
      end
    end
  end

  describe "POST /api/v1/:chat_id/messages" do
    let(:message_params) do
      { message: { content: "Hello world!" } }
    end

    before do
      post("/api/v1/chats/#{chat.id}/messages", 
           params: message_params,
           headers: headers)
    end

    context "valid request" do
      it "returns a 'no content' response status" do
        expect(response).to have_http_status 204
      end

      it "creates a new message" do
        expect(Message.count).to eq 25
      end
    end

    context "unauthorized user" do
      let(:headers) do
        { Authorization: generate_token(eavesdropper.id) }
      end

      it "returns a 'forbidden' response status" do
        expect(response).to have_http_status 403
      end

      it "returns an error message" do
        expect(json["message"]).to match /Access denied/
      end
    end
  end
end
