class UrlThumbnailer::FetchMetaJob < ApplicationJob
  queue_as :fetch_url_meta

  # Maybe try to get info on when we can retry from the exception itself if host
  # exposes headers with that info?
  retry_on Faraday::TooManyRequestsError, wait: :polynomially_longer, attempts: 5

  def perform(post)
    UrlThumbnailer.new(post).call
  end
end
