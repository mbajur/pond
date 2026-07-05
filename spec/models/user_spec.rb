# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  it { is_expected.to have_many(:sessions) }
  it { is_expected.to have_many(:collections) }
  it { is_expected.to have_many(:auth_codes) }
  it { is_expected.to have_many(:follows_as_actor) }
  it { is_expected.to have_many(:follows_as_target) }
  it { is_expected.to have_many(:followers) }
  it { is_expected.to have_many(:following_users) }
  it { is_expected.to have_many(:following_collections) }

  describe ".find_by_username!" do
    let!(:user) { create(:user, username: "alice") }

    it "finds a user by username" do
      expect(described_class.find_by_username!("alice")).to eq(user)
    end

    it "strips a leading @ from the username" do
      expect(described_class.find_by_username!("@alice")).to eq(user)
    end

    it "raises ActiveRecord::RecordNotFound when the user does not exist" do
      expect { described_class.find_by_username!("nobody") }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#premium?" do
    it "returns true when premium_until is in the future" do
      user = create(:user, premium_until: 1.day.from_now)
      expect(user.premium?).to be true
    end

    it "returns false when premium_until is in the past" do
      user = create(:user, premium_until: 1.day.ago)
      expect(user.premium?).to be false
    end

    it "returns false when premium_until is nil" do
      user = create(:user, premium_until: nil)
      expect(user.premium?).to be false
    end
  end

  describe "after_create :create_inbox_collection" do
    it "creates an inbox collection on user creation" do
      user = create(:user)
      expect(user.collections.where(inbox: true).count).to eq(1)
    end

    it "creates the inbox collection with the name 'Inbox'" do
      user = create(:user)
      expect(user.collections.find_by(inbox: true).name).to eq("Inbox")
    end

    it "creates the inbox collection as private" do
      user = create(:user)
      expect(user.collections.find_by(inbox: true).private).to be true
    end

    it "does not create a second inbox on subsequent saves" do
      user = create(:user)
      expect { user.update!(username: "#{user.username}_updated") }
        .not_to change { user.collections.where(inbox: true).count }
    end
  end
end
