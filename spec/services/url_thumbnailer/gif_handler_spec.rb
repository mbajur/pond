# frozen_string_literal: true

require "rails_helper"

describe UrlThumbnailer::GifHandler do
  let(:post) { create(:post) }
  let(:gif_fixture) { Rails.root.join("spec/fixtures/files/1x1.gif") }

  describe ".match?" do
    it "matches image/gif responses" do
      preflight = instance_double(Faraday::Response, headers: { "content-type" => "image/gif" })
      expect(described_class.match?(post: post, preflight: preflight)).to be true
    end

    it "does not match other content types" do
      preflight = instance_double(Faraday::Response, headers: { "content-type" => "text/html" })
      expect(described_class.match?(post: post, preflight: preflight)).to be false
    end
  end

  describe ".screenshotable?" do
    it "is always false" do
      expect(described_class.screenshotable?(post)).to be false
    end
  end

  describe "#process_meta" do
    subject(:handler) { described_class.new(post: post, preflight: nil) }

    let(:post_url) { "https://example.com/cat.gif" }
    let(:post) { create(:post, url: post_url) }

    before do
      # Post::Url itself validates :url via URI.parse(url).host, so we can't
      # replace the parsed URI wholesale - only stub #open on the instance the
      # handler parses, and let everything else (host, scheme, path) be real.
      allow(URI).to receive(:parse).and_wrap_original do |original, arg|
        uri = original.call(arg)
        allow(uri).to receive(:open).and_return(File.open(gif_fixture, "rb")) if arg == post_url
        uri
      end
    end

    it "attaches the gif directly as the thumbnail, unprocessed" do
      handler.process_meta

      expect(post.thumb).to be_attached
      expect(post.thumb.content_type).to eq("image/gif")
      expect(post.thumb.blob.byte_size).to eq(File.size(gif_fixture))
    end

    it "sets the post title to the file's basename" do
      handler.process_meta

      expect(post.title).to eq("cat.gif")
    end
  end

  describe "#process_screenshot" do
    it "raises NotImplementedError" do
      handler = described_class.new(post: post, preflight: nil)

      expect { handler.process_screenshot }.to raise_error(NotImplementedError)
    end
  end
end
