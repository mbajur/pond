# frozen_string_literal: true

require "rails_helper"

describe UrlThumbnailer::YoutubeVideoHandler do
  describe ".match?" do
    it "matches a youtube.com watch URL without www" do
      post = build_stubbed(:post, url: "https://youtube.com/watch?v=dQw4w9WgXcQ")
      expect(described_class.match?(post: post, preflight: nil)).to be true
    end

    it "matches a youtube.com watch URL with www and extra query params" do
      post = build_stubbed(:post, url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=30s")
      expect(described_class.match?(post: post, preflight: nil)).to be true
    end

    it "matches a youtu.be short link" do
      post = build_stubbed(:post, url: "https://youtu.be/dQw4w9WgXcQ")
      expect(described_class.match?(post: post, preflight: nil)).to be true
    end

    it "matches a youtu.be short link with extra query params" do
      post = build_stubbed(:post, url: "https://youtu.be/dQw4w9WgXcQ?t=30")
      expect(described_class.match?(post: post, preflight: nil)).to be true
    end

    it "does not match the bare youtu.be domain" do
      post = build_stubbed(:post, url: "https://youtu.be/")
      expect(described_class.match?(post: post, preflight: nil)).to be false
    end

    it "does not match a non-watch youtube page" do
      post = build_stubbed(:post, url: "https://www.youtube.com/channel/UCxyz")
      expect(described_class.match?(post: post, preflight: nil)).to be false
    end

    it "does not match a watch URL without a v= query param" do
      post = build_stubbed(:post, url: "https://www.youtube.com/watch?list=PL123")
      expect(described_class.match?(post: post, preflight: nil)).to be false
    end

    it "does not match non-youtube URLs" do
      post = build_stubbed(:post, url: "https://example.com/watch?v=abc")
      expect(described_class.match?(post: post, preflight: nil)).to be false
    end
  end

  describe ".screenshotable?" do
    it "is always false" do
      post = build_stubbed(:post)
      expect(described_class.screenshotable?(post)).to be false
    end
  end

  describe "#process_screenshot" do
    it "raises NotImplementedError" do
      post = build_stubbed(:post)
      handler = described_class.new(post: post, preflight: nil)

      expect { handler.process_screenshot }.to raise_error(NotImplementedError)
    end
  end

  describe "#process_meta" do
    # Not overridden - inherits UrlThumbnailer::DefaultHandler's implementation.
    let(:post) { create(:post, url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ") }
    let(:thumb_fixture) { Rails.root.join("spec/fixtures/files/1x1.jpg") }

    let(:link_object) do
      double(
        title: "Rick Astley - Never Gonna Give You Up",
        description: "The official video",
        images: [ double(src: "https://example.com/thumb.jpg") ]
      )
    end

    subject(:handler) { described_class.new(post: post, preflight: nil) }

    before do
      allow(LinkThumbnailer).to receive(:generate).with(post.url).and_return(link_object)
      allow(handler).to receive(:download_thumb).and_return(double(body: thumb_fixture.binread))
    end

    it "updates title/description and attaches the thumbnail via the inherited behavior" do
      handler.process_meta

      expect(post.title).to eq("Rick Astley - Never Gonna Give You Up")
      expect(post.description).to eq("The official video")
      expect(post.thumb).to be_attached
    end
  end
end
