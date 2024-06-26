require 'rails_helper'

RSpec.describe Message, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :messageable }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_length_of(:content).is_at_most(1000) }

end
