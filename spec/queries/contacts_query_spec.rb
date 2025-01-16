require "rails_helper"

RSpec.describe ContactsQuery do
  let(:user) { create :user }
  let!(:other_users) { create_list :user, 10 }
  let!(:chat_list) do
    other_users.map do |u|
      create :chat, users: [user, u]
    end
  end

  subject { described_class.new(user) }

  describe "#call" do
    it "should return the list of user contacts" do
      expect(subject.call).to match_array other_users
    end

    it "should exclude the user from the list" do
      expect(subject.call).not_to include user
    end

    it "should not contain duplicate entries" do
      # create a 'duplicate' chat room
      create :chat, users: [user, other_users.first]

      expect(subject.call.size).to eq chat_list.size
    end

    it "should exclude other users who are not in contact with the user" do
      # create a new user
      new_user = create :user

      expect(subject.call).not_to include new_user
    end
  end
end
