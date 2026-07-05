# It is here because order is important - we have to prepend this analyzer
# before the blurhash one. If it's not here, we are not able to use after_initialize
# hook.
require_relative "../../lib/active_storage/vips_color_analyzer.rb"

Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy

Rails.application.config.after_initialize do
  Rails.application.config.active_storage.analyzers.prepend(ActiveStorage::VipsColorAnalyzer)
end
