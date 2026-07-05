# frozen_string_literal: true

require "rails_helper"

describe UrlThumbnailer::ProcessScreenshotHandlerJob, type: :job do
  describe "#perform" do
    it "processes the screenshot via the given handler class and refreshes the post's pin cards" do
      post = instance_double(Post, refresh_pins_cards: nil)
      handler = double("Handler", process_screenshot: nil)
      handler_class = double("HandlerClass", new: handler)

      described_class.perform_now(post, handler_class: handler_class)

      expect(handler_class).to have_received(:new).with(post: post, preflight: nil)
      expect(handler).to have_received(:process_screenshot)
      expect(post).to have_received(:refresh_pins_cards)
    end
  end

  it "is queued on the screenshoter queue" do
    expect(described_class.new.queue_name).to eq("screenshoter")
  end

  it "retries on Ferrum::DeadBrowserError" do
    expect(described_class.rescue_handlers.map(&:first)).to include("Ferrum::DeadBrowserError")
  end
end
