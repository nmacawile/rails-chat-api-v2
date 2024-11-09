require "rails_helper"

RSpec.describe NotificationsChannel, type: :channel do
  let(:user) { create :user }

  context "subscription" do
    it "subscribes to own notifications stream" do
      stub_connection current_user: user
      subscribe(user_id: user.id)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(user)
    end
  end
end
