class UrlThumbnailer::YoutubeVideoHandler < UrlThumbnailer::DefaultHandler
  # Maybe regexp would be more elegant?
  def self.match?(post:, preflight:)
    uri = URI.parse(post.url)

    if uri.host&.include?("youtube.com")
      uri.path == "/watch" && uri.query&.include?("v=")
    elsif uri.host == "youtu.be"
      uri.path.present? && uri.path != "/"
    else
      false
    end
  end

  def self.screenshotable?(post)
    false
  end

  def process_screenshot
    raise NotImplementedError
  end
end
