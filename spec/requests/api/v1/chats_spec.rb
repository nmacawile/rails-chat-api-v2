require 'rails_helper'

RSpec.describe "Chats", type: :request do
  let(:user) { create :user }
  let(:friends) { create_list :user, 20 }

  let(:user_chats) do
    friends.map do |friend|
      Chat.create users: [user, friend]
    end
  end

  let!(:user_chat_messages) do
    2.times.map do |n|
      create :message, messageable: user_chats[n], user: user
    end
  end

  let!(:user_chats_hash) do
    [
      { 
        "id" => user_chats.second.id,
        "type" => "Chat",
        "users" => [user.data, friends.second.data],
        "latest_message" => {
          "content" => user_chat_messages.second.content,
          "user" => user.data
        }
      },
      { 
        "id" => user_chats.first.id,
        "type" => "Chat",
        "users" => [user.data, friends.first.data],
        "latest_message" => {
          "content" => user_chat_messages.first.content,
          "user" => user.data
        }
      }
    ]
  end
  
  let(:headers) do
    { "Authorization" => "Bearer #{generate_token(user.id)}" }
  end

  describe "GET api/v1/chats" do
    before { get "/api/v1/chats", headers: headers }

    it "returns an 'ok' response status" do
      expect(response).to have_http_status 200
    end

    it "returns all non-empty chats authenticated user has joined in" do
      expect(json).to eq user_chats_hash
    end
  end

  describe "GET api/v1/chats" do
    let(:chat) { user_chats.first }
    let(:chat_id) { chat.id }
    let(:chat_hash) do
      {
        "id" => chat.id,
        "users" => chat.users.map { |u| u.data }
      }
    end
    
    before { get "/api/v1/chats/#{chat_id}", headers: headers }

    context "when chat exists" do
      it "returns the chat object" do
        expect(json).to eq chat_hash
      end

      it "returns an 'ok' response status" do
        expect(response).to have_http_status 200
      end
    end

    context "when chat doesn't exist" do
      let(:chat_id) { 0 }

      it "returns a 'not found' response status" do
        expect(response).to have_http_status 404
      end

      it "returns a 'not found' message" do
        expect(json["message"]).to match /Couldn't find Chat/
      end
    end

    context "when user doesn't belong in the chat" do
      let(:unauthorized_user) { create :user }
      let(:headers) do
        { "Authorization" => "Bearer #{generate_token(unauthorized_user.id)}" }
      end

      it "returns a 'forbidden' response status" do
        expect(response).to have_http_status 403
      end

      it "returns a 'forbidden' message" do
        expect(json["message"]).to match /Access denied/
      end
    end
  end
end
