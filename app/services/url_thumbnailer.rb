class UrlThumbnailer
  HANDLERS = [
    UrlThumbnailer::InstagramProfileHandler,
    UrlThumbnailer::YoutubeVideoHandler,
    UrlThumbnailer::GifHandler,
    UrlThumbnailer::ImageHandler,
    UrlThumbnailer::DefaultHandler
  ]

  def initialize(post)
    @post = post
  end

  def call
    logger.info "Running preflight check for URL: #{@post.url}..."
    preflight = Faraday.head(@post.url)
    return unless preflight.success?

    logger.info "Preflight check successful for URL: #{@post.url}. Selecting handler..."
    handler_class = HANDLERS.find { |handler| handler.match?(post: @post, preflight: preflight) }

    logger.info "Selected #{handler_class.name} for URL: #{@post.url}" if handler_class
    raise Screenshoter::UnsupportedLinkType.new("No handler found for this URL") unless handler_class

    logger.info "Running metadata processing for URL: #{@post.url}..."
    handler_class.new(post: @post, preflight: preflight).process_meta

    if handler_class.screenshotable?(@post)
      logger.info "Handler #{handler_class.name} supports screenshots. Processing screenshot for URL: #{@post.url}..."
      UrlThumbnailer::ProcessScreenshotHandlerJob.perform_later(@post, handler_class: handler_class)
    else
      logger.info "Handler #{handler_class.name} does not support screenshots. Skipping screenshot processing for URL: #{@post.url}."
    end

    logger.info "All set. Refreshing pin cards for URL: #{@post.url}..."
    @post.refresh_pins_cards
  end

  private

  def logger
    @logger ||= Rails.logger
  end
end
