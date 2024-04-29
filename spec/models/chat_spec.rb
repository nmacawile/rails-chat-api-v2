require 'rails_helper'

RSpec.describe Chat, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:joins).dependent(:destroy) }
  it { is_expected.to have_many(:messages).dependent(:destroy) }
  it { is_expected.to belong_to(:latest_message).optional }
  
  describe "Updates the record when a message is created" do
    let(:users) { create_list :user, 2 }
    subject { create :chat, users: users }

    before do
      subject.messages.build(
        content: Faker::Lorem.paragraph,
        user: users.first
      )
    end
  
    it "updates the timestamp when a message is added" do
      expect { subject.save }.to change { subject.updated_at }
    end

    it "updates the latest message when a message is added" do
      expect { subject.save }.to change { subject.latest_message }
    end
  end
end
