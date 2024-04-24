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
end
