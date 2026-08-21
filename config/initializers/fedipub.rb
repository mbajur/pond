Fedipub.config_from "fedipub"

if Rails.env.production?
  Fedipub.configure do |config|
    config.site_host = "https://#{Figaro.env.host}"
    config.open_registrations = false
  end
end
