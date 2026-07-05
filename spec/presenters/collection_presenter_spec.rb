# frozen_string_literal: true

require "rails_helper"

describe CollectionPresenter do
  describe "#name" do
    it "returns the collection's name for a regular collection" do
      collection = build_stubbed(:collection, name: "Recipes", inbox: false)
      expect(described_class.new(collection).name).to eq("Recipes")
    end

    it "returns \"Inbox\" for the inbox collection, regardless of its name" do
      collection = build_stubbed(:collection, name: "Whatever", inbox: true)
      expect(described_class.new(collection).name).to eq("Inbox")
    end
  end

  describe "#description" do
    it "returns the collection's description for a regular collection" do
      collection = build_stubbed(:collection, description: "My favorite recipes", inbox: false)
      expect(described_class.new(collection).description).to eq("My favorite recipes")
    end

    it "returns a fixed description for the inbox collection, regardless of its description" do
      collection = build_stubbed(:collection, description: "Whatever", inbox: true)
      expect(described_class.new(collection).description).to eq(
        "Pins visible only to you, not assigned to any collection yet."
      )
    end
  end
end
