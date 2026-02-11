require 'rails_helper'

RSpec.describe PresenceConnection, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :connection_id }
  it { is_expected.to validate_presence_of :last_seen }
end
