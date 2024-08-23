require "rails_helper"

RSpec.describe ChatChannel, type: :channel do
  let(:user) { create :user }
  let(:friend) { create :user }
  let(:eavesdropper) { create :user }
  let(:chat)  { create :chat, users: [user, friend] }

  context "subscription" do
    it "subscribes to a chat stream where user is a member of" do
      stub_connection current_user: user
      subscribe(chat_id: chat.id)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(chat)
    end

    it "rejects chat subscription where user is not a member of" do
      stub_connection current_user: eavesdropper
      subscribe(chat_id: chat.id)
      expect(subscription).to be_rejected
    end

    it "rejects subscription where chat does not exist" do
      stub_connection current_user: user
      subscribe(chat_id: 0)
      expect(subscription).to be_rejected
    end
  end
end
