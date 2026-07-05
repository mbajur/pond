# frozen_string_literal: true

require "rails_helper"

describe UrlThumbnailer::InstagramProfileHandler do
  describe ".match?" do
    it "matches a profile URL without www" do
      post = build_stubbed(:post, url: "https://instagram.com/mbajur")
      expect(described_class.match?(post: post, preflight: nil)).to be true
    end

    it "matches a profile URL with www and a trailing slash" do
      post = build_stubbed(:post, url: "https://www.instagram.com/mbajur/")
      expect(described_class.match?(post: post, preflight: nil)).to be true
    end

    it "matches over plain http" do
      post = build_stubbed(:post, url: "http://www.instagram.com/mbajur/")
      expect(described_class.match?(post: post, preflight: nil)).to be true
    end

    it "does not match a nested path under the profile (e.g. a post)" do
      post = build_stubbed(:post, url: "https://www.instagram.com/mbajur/posts/")
      expect(described_class.match?(post: post, preflight: nil)).to be false
    end

    it "does not match the bare instagram.com domain" do
      post = build_stubbed(:post, url: "https://www.instagram.com/")
      expect(described_class.match?(post: post, preflight: nil)).to be false
    end

    it "does not match non-instagram URLs" do
      post = build_stubbed(:post, url: "https://example.com/mbajur/")
      expect(described_class.match?(post: post, preflight: nil)).to be false
    end
  end

  describe ".screenshotable?" do
    it "is always false" do
      post = build_stubbed(:post)
      expect(described_class.screenshotable?(post)).to be false
    end
  end

  describe "#process_meta" do
    it "sets the post title to instagram.com/<username>" do
      post = create(:post, url: "https://www.instagram.com/mbajur/")
      handler = described_class.new(post: post, preflight: nil)

      handler.process_meta

      expect(post.title).to eq("instagram.com/mbajur")
    end

    it "extracts the username without www or a trailing slash" do
      post = create(:post, url: "https://instagram.com/mbajur")
      handler = described_class.new(post: post, preflight: nil)

      handler.process_meta

      expect(post.title).to eq("instagram.com/mbajur")
    end

    it "leaves the title untouched when the URL does not match a profile" do
      post = create(:post, url: "https://www.instagram.com/mbajur/posts/")
      handler = described_class.new(post: post, preflight: nil)

      handler.process_meta

      expect(post.title).to be_nil
    end
  end

  describe "#process_screenshot" do
    it "raises NotImplementedError" do
      post = build_stubbed(:post)
      handler = described_class.new(post: post, preflight: nil)

      expect { handler.process_screenshot }.to raise_error(NotImplementedError)
    end
  end
end
