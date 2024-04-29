require "rails_helper"

RSpec.describe ChatBetweenUsersQuery do
  describe "#call" do
    let(:user1) { create :user }
    let(:user2) { create :user }

    let(:pair) { [user1, user2] }
    
    subject { described_class.new pair }

    context "when a chat exists" do
      let!(:chat) { create :chat, users: pair }

      it "returns the chat between two users" do
        expect(subject.call).to eq chat
      end
    end

    context "when a chat doesn't exist" do      
      it "returns nil" do
        expect(subject.call).to be_nil
      end
    end
  end
end
