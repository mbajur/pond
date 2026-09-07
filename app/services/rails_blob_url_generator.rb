class RailsBlobUrlGenerator
  def initialize(variant)
    @variant = variant
  end

  def call
    if ENV["CDN_HOST"].present?
      Rails.application.routes.url_helpers.rails_storage_proxy_url(@variant, host: ENV["CDN_HOST"])
    else
      Rails.application.routes.url_helpers.rails_representation_path(@variant, only_path: true)
    end
  end
end
