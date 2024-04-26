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
    context "when chat exists" do
      let(:chat) { user_chats.first }
      let(:chat_users) { chat.users }
      let(:chat_hash) do
        {
          "id" => chat.id,
          "users" => chat.users.map { |u| u.data }
        }
      end

      before { get "/api/v1/chats/#{chat.id}", headers: headers }

      it "returns the chat object" do
        expect(json).to eq chat_hash
      end

      it "returns an 'ok' response status" do
        expect(response).to have_http_status 200
      end
    end

    context "when chat doesn't exist" do
      before { get "/api/v1/chats/0", headers: headers }

      it "returns a 'not found' response status" do
        expect(response).to have_http_status 404
      end

      it "returns a 'not found' message" do
        expect(json["message"]).to match /Couldn't find Chat/
      end
    end
  end
end
