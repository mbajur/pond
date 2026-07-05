# frozen_string_literal: true

require 'rails_helper'

describe Collection, type: :model do
  it { is_expected.to have_many(:pins) }
  it { is_expected.to have_many(:pins_as_pinable) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:name) }

  describe "only_one_inbox_per_user validation" do
    let(:user) { create(:user) }

    it "is invalid when a second inbox is added for the same user" do
      duplicate = build(:collection, inbox: true, user: user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:inbox]).to include("can only have one inbox collection per user")
    end

    it "does not apply to regular (non-inbox) collections" do
      regular = build(:collection, inbox: false, user: user)
      expect(regular).to be_valid
    end
  end

  describe ".search" do
    let(:user) { create(:user, username: "alice", email_address: "alice@example.com") }
    let(:other_user) { create(:user, username: "bobsmith", email_address: "bob@example.com") }

    let!(:matching_by_name) { create(:collection, name: "Design Inspiration", user: user) }
    let!(:matching_by_user) { create(:collection, name: "Random Stuff", user: other_user) }
    let!(:no_match) { create(:collection, name: "Photography", user: user) }

    it "finds collections by name" do
      expect(described_class.search("Design")).to include(matching_by_name)
      expect(described_class.search("Design")).not_to include(no_match)
    end

    it "finds collections by username" do
      expect(described_class.search("bobsmith")).to include(matching_by_user)
      expect(described_class.search("bobsmith")).not_to include(matching_by_name)
    end

    it "returns all results when query is blank" do
      expect(described_class.search("")).to include(matching_by_name, matching_by_user, no_match)
    end
  end
end
