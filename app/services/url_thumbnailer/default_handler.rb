class UrlThumbnailer::DefaultHandler
  SCREEN_WIDTH = 1440
  SCREEN_HEIGHT = 1440

  class ResponseStatusInvalidError < StandardError; end

  def initialize(post:, preflight:, logger: Rails.logger)
    @post = post
    @preflight = preflight
    @logger = logger
  end

  def self.match?(post:, preflight:)
    preflight.headers["content-type"].to_s.start_with?("text/html")
  end

  def self.screenshotable?(post)
    true
  end

  def process_meta
    logger.info "Processing metadata for URL: #{@post.url}..."

    object = LinkThumbnailer.generate(@post.url)
    @post.update!(
      title: object.title,
      description: object.description
    )

    return unless object.images.any?

    image_url = object.images.first.src
    logger.info "Downloading thumbnail from URL: #{image_url}..."

    begin
      downloaded_image = download_thumb(image_url)
      ext = File.extname(URI.parse(image_url).path).presence || ".jpg"
      tmp = Tempfile.new([ "thumbnail", ext ]).tap { |f| f.binmode; f.write(downloaded_image.body); f.flush; f.rewind }

      logger.info "Attaching thumbnail to URL cache for URL: #{@post.url}..."
      @post.thumb.attach(process_image(tmp))
      @post.save!
    rescue Faraday::ResourceNotFound, Faraday::ForbiddenError => e
      # Do not report that anywhere, there will be a lot of cases like this and we can't do much about that.
      logger.warn "Thumbnail not found at URL: #{image_url} for post URL: #{@post.url}. Error: #{e.message}"
    end
  end

  def process_screenshot
    logger.info "Processing screenshot for URL: #{@post.url}..."

    page = browser.create_page

    page.go_to(@post.url)
    status = page.network.status
    raise ResponseStatusInvalidError.new("Invalid response status: #{status}") if status != 200

    page.set_viewport(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    sleep 5

    file = Tempfile.new([ "screenshot", ".png" ])
    page.screenshot(path: file.path)

    @post.screenshot.attach(process_image(file))
  end

  private

  attr_reader :logger

  def browser
    @browser ||= Ferrum::Browser.new(
      ws_url: Figaro.env.screenshoter_ws_url,
      pending_connection_errors: false,
      timeout: 240
    )
  end

  def process_image(file)
    Image::Operation::Process.call(params: { image: file })[:output]
  end

  def download_thumb(url)
    thumb_downloader_client.get(url)
  end

  def thumb_downloader_client
    @thumb_downloader_client ||= Faraday.new do |faraday|
      faraday.request :retry, max: 3, interval: 0.5, backoff_factor: 2
      faraday.response :follow_redirects
      faraday.response :raise_error
      faraday.adapter Faraday.default_adapter
    end
  end
end
