class UrlThumbnailer::InstagramProfileHandler < UrlThumbnailer::DefaultHandler
  # Make regexp to match insagram profiles, so for example https://www.instagram.com/mbajur/
  def self.match?(post:, preflight:)
    post.url.match?(/https?:\/\/(www\.)?instagram\.com\/[^\/]+\/?$/)
  end

  def self.screenshotable?(post)
    false
  end

  def process_meta
    logger.info "Processing metadata for URL: #{@post.url}..."

    # Extract the username from the URL using regex
    username_match = @post.url.match(/https?:\/\/(www\.)?instagram\.com\/([^\/]+)\/?$/)

    if username_match
      username = username_match[2]
      @post.update!(title: "instagram.com/#{username}")
    end
  end

  def process_screenshot
    raise NotImplementedError
  end
end
