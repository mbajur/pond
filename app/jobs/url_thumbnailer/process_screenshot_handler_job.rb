class UrlThumbnailer::ProcessScreenshotHandlerJob < ApplicationJob
  queue_as :screenshoter
  limits_concurrency to: 1, key: ->(*) { "screenshoter" }

  retry_on Ferrum::DeadBrowserError, wait: :polynomially_longer, attempts: 5

  def perform(post, handler_class:)
    handler_class.new(post: post, preflight: nil).process_screenshot
    post.refresh_pins_cards
  end
end
