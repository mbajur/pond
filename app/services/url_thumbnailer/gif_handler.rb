class UrlThumbnailer::GifHandler < UrlThumbnailer::DefaultHandler
  def self.match?(post:, preflight:)
    preflight.headers["content-type"].to_s.start_with?("image/gif")
  end

  def self.screenshotable?(post)
    false
  end

  def process_meta
    logger.info "Processing metadata for URL: #{@post.url}..."

    filename = File.basename(URI.parse(@post.url).path)
    @post.thumb.attach(io: URI.parse(@post.url).open, filename: filename)
    @post.update!(title: filename)
  end

  def process_screenshot
    raise NotImplementedError
  end
end
