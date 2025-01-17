require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :handle }
  it { is_expected.to have_many(:joins).dependent(:destroy) }
  it { is_expected.to have_many(:chats) }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to have_db_column(:last_seen).of_type(:datetime) }
  it { is_expected.to have_db_column(:visibility).of_type(:boolean) }

  describe "#full_name" do
    let(:first_name) { subject.first_name }
    let(:last_name) { subject.last_name }

    it "returns the full name" do
      expect(subject.full_name).to eq "#{first_name} #{last_name}"
    end
  end

  describe "#data" do
    subject { create :user }
    let(:data) { subject.data }

    it "includes the first name" do
      expect(data["first_name"]).not_to be_nil
    end

    it "includes the last name" do
      expect(data["last_name"]).not_to be_nil
    end

    it "includes the id" do
      expect(data["id"]).not_to be_nil
    end

    it "includes the full name" do
      expect(data["full_name"]).not_to be_nil
    end

    it "includes the handle" do
      expect(data["handle"]).not_to be_nil
    end

    it "includes the visibility" do
      expect(data["visibility"]).not_to be_nil
    end

    it "includes the last seen" do
      expect(data["last_seen"]).not_to be_nil
    end

    it "doesn't include the email" do
      expect(data["email"]).to be_nil
    end
  end

  describe "#complete_data" do
    subject { create :user }
    let(:data) { subject.complete_data }

    it "includes the first name" do
      expect(data["first_name"]).not_to be_nil
    end

    it "includes the last name" do
      expect(data["last_name"]).not_to be_nil
    end

    it "includes the id" do
      expect(data["id"]).not_to be_nil
    end

    it "includes the full name" do
      expect(data["full_name"]).not_to be_nil
    end

    it "includes the handle" do
      expect(data["handle"]).not_to be_nil
    end

    it "includes the visibility" do
      expect(data["visibility"]).not_to be_nil
    end

    it "includes the last seen" do
      expect(data["last_seen"]).not_to be_nil
    end

    it "includes the email" do
      expect(data["email"]).not_to be_nil
    end
  end
end
