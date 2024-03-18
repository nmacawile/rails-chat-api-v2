require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to have_many(:joins).dependent(:destroy) }
  it { is_expected.to have_many(:chats) }
  it { is_expected.to have_many(:messages) }


  describe "#full_name" do
    let(:first_name) { subject.first_name }
    let(:last_name) { subject.last_name }

    it "returns the full name" do
      expect(subject.full_name).to eq "#{first_name} #{last_name}"
    end
  end
end
