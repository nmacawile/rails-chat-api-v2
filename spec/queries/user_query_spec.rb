require "rails_helper"

RSpec.describe UserQuery do
  let(:users) do
    create_list :user, 2, first_name: "Aaa", last_name: "Bbb"
  end

  let(:user) do
    create :user, first_name: "Foo", last_name: "Bar"
  end

  subject { described_class.new(query_string) }
  
  describe "#call" do
    context "when query string is empty" do
      let(:query_string) { nil }
      
      it "returns all items from the list" do
        expect(subject.call).to eq users
      end
    end

    context "when query string exactly matches user's full name" do
      let(:query_string) { "Foo Bar" }
      
      it "returns a list including the matching user" do
        expect(subject.call).to eq [user]
      end
    end

    context "when query string partially matches user's full name" do
      let(:query_string) { "Bar Foo" }

      it "returns a list including the matching user" do
        expect(subject.call).to eq [user]
      end
    end

    context "when query string has random capitalization" do
      let(:query_string) { "foO Bar" }

      it "returns a list including the matching user" do
        expect(subject.call).to eq [user]
      end
    end
  end
end
