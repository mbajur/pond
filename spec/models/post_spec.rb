# frozen_string_literal: true

require 'rails_helper'

describe Post, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:pins) }
  it { is_expected.to have_many(:collections) }

  describe ".search" do
    let!(:user)       { create(:user, username: "alice") }
    let!(:other_user) { create(:user, username: "bobsmith") }

    let!(:by_title)   { create(:post, user: user, title: "Design Patterns Guide", url: "https://example.com/1") }
    let!(:by_content) { create(:post, user: user, content: "Notes on refactoring legacy systems", url: "https://example.com/2") }
    let!(:by_url)     { create(:post, user: user, url: "https://ruby-lang.org") }
    let!(:by_user)    { create(:post, user: other_user, url: "https://example.com/3") }
    let!(:no_match)   { create(:post, user: user, title: "Photography tips", url: "https://example.com/4") }

    it "finds posts by title" do
      expect(described_class.search("Design")).to include(by_title)
      expect(described_class.search("Design")).not_to include(no_match)
    end

    it "finds posts by content" do
      expect(described_class.search("refactoring")).to include(by_content)
      expect(described_class.search("refactoring")).not_to include(no_match)
    end

    it "finds posts by url" do
      expect(described_class.search("ruby-lang")).to include(by_url)
      expect(described_class.search("ruby-lang")).not_to include(no_match)
    end

    it "finds posts by username" do
      expect(described_class.search("bobsmith")).to include(by_user)
      expect(described_class.search("bobsmith")).not_to include(by_title)
    end

    it "returns all results when query is blank" do
      expect(described_class.search("")).to include(by_title, by_content, by_url, by_user, no_match)
    end
  end
end
