# frozen_string_literal: true

require 'rails_helper'

describe Pin, type: :model do
  it { is_expected.to belong_to(:pinable) }
  it { is_expected.to belong_to(:collection) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:collection_id) }

  describe "unique_per_collection validation" do
    let(:user)       { create(:user) }
    let(:collection) { create(:collection, user: user) }
    let(:post)       { create(:post, user: user, url: "https://example.com") }

    def pin_post_to(col)
      Pin.create!(user: user, collection: col, pinable: post)
    end

    it "is invalid when the same item is pinned to the same collection twice" do
      pin_post_to(collection)
      duplicate = Pin.new(user: user, collection: collection, pinable: post)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:base]).to include("This item is already pinned in the selected collection.")
    end

    it "is valid when the same item is pinned to a different collection" do
      pin_post_to(collection)
      other_collection = create(:collection, user: user)
      pin = Pin.new(user: user, collection: other_collection, pinable: post)
      expect(pin).to be_valid
    end

    it "is valid when a different item is pinned to the same collection" do
      pin_post_to(collection)
      other_post = Post.create!(user: user, url: "https://other.com")
      pin = Pin.new(user: user, collection: collection, pinable: other_post)
      expect(pin).to be_valid
    end

    it "does not fire when updating a pin without changing the collection" do
      pin = pin_post_to(collection)
      pin.touch
      expect(pin).to be_valid
    end
  end
end
