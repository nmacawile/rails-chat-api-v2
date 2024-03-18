require 'rails_helper'

RSpec.describe Chat, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:joins).dependent(:destroy) }
  it { is_expected.to have_many(:messages).dependent(:destroy) }
end
