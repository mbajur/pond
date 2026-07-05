# frozen_string_literal: true

require "rails_helper"

describe UrlThumbnailer::DefaultHandler do
  let(:post) { create(:post) }
  let(:thumb_fixture) { Rails.root.join("spec/fixtures/files/1x1.jpg") }
  let(:screenshot_fixture) { Rails.root.join("spec/fixtures/files/screenshot.png") }

  describe ".match?" do
    it "matches text/html responses" do
      preflight = instance_double(Faraday::Response, headers: { "content-type" => "text/html; charset=utf-8" })
      expect(described_class.match?(post: post, preflight: preflight)).to be true
    end

    it "does not match other content types" do
      preflight = instance_double(Faraday::Response, headers: { "content-type" => "image/png" })
      expect(described_class.match?(post: post, preflight: preflight)).to be false
    end
  end

  describe ".screenshotable?" do
    it "is always true" do
      expect(described_class.screenshotable?(post)).to be true
    end
  end

  describe "#process_meta" do
    subject(:handler) { described_class.new(post: post, preflight: nil) }

    let(:link_object) do
      double(
        title: "Some title",
        description: "Some description",
        images: [ double(src: "https://example.com/thumb.jpg") ]
      )
    end

    before do
      allow(LinkThumbnailer).to receive(:generate).with(post.url).and_return(link_object)
    end

    it "updates the post's title and description" do
      handler.process_meta

      expect(post.title).to eq("Some title")
      expect(post.description).to eq("Some description")
    end

    context "when the linked page has a thumbnail image" do
      before do
        allow(handler).to receive(:download_thumb).and_return(double(body: thumb_fixture.binread))
      end

      it "downloads, processes and attaches the thumbnail" do
        handler.process_meta

        expect(post.thumb).to be_attached
        expect(post.thumb.content_type).to eq("image/webp")
      end
    end

    context "when the linked page has no images" do
      let(:link_object) { double(title: "T", description: "D", images: []) }

      it "does not attach a thumbnail" do
        handler.process_meta

        expect(post.thumb).not_to be_attached
      end
    end

    context "when downloading the thumbnail 404s" do
      before do
        allow(handler).to receive(:download_thumb).and_raise(Faraday::ResourceNotFound.new("not found"))
      end

      it "does not raise and leaves the thumbnail unattached" do
        expect { handler.process_meta }.not_to raise_error
        expect(post.thumb).not_to be_attached
      end
    end

    context "when downloading the thumbnail is forbidden" do
      before do
        allow(handler).to receive(:download_thumb).and_raise(Faraday::ForbiddenError.new("forbidden"))
      end

      it "does not raise and leaves the thumbnail unattached" do
        expect { handler.process_meta }.not_to raise_error
        expect(post.thumb).not_to be_attached
      end
    end
  end

  describe "#process_screenshot" do
    subject(:handler) { described_class.new(post: post, preflight: nil) }

    let(:browser) { instance_double(Ferrum::Browser) }
    let(:page) { instance_double(Ferrum::Page) }
    let(:network) { instance_double(Ferrum::Network, status: 200) }

    before do
      allow(handler).to receive(:sleep)
      allow(Ferrum::Browser).to receive(:new).and_return(browser)
      allow(browser).to receive(:create_page).and_return(page)
      allow(page).to receive(:go_to)
      allow(page).to receive(:network).and_return(network)
      allow(page).to receive(:set_viewport)
      allow(page).to receive(:screenshot) do |path:|
        FileUtils.cp(screenshot_fixture, path)
      end
    end

    it "captures and attaches a screenshot" do
      handler.process_screenshot

      expect(post.screenshot).to be_attached
      expect(post.screenshot.content_type).to eq("image/webp")
    end

    context "when the page responds with a non-200 status" do
      let(:network) { instance_double(Ferrum::Network, status: 500) }

      it "raises ResponseStatusInvalidError and does not attach a screenshot" do
        expect { handler.process_screenshot }.to raise_error(described_class::ResponseStatusInvalidError, /500/)
        expect(post.screenshot).not_to be_attached
      end
    end
  end
end
