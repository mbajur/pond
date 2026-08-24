Fedipub.config_from "fedipub"

if Rails.env.production?
  Fedipub.configure do |config|
    config.site_host = "https://#{Figaro.env.host}"
    config.open_registrations = false
  end
end

Rails.application.config.to_prepare do
  Fedipub::ServerController.class_eval do
    include Authentication

    private

    def pundit_user
      resume_session && current_user
    end
  end

  Fedipub::Server::PublishedController.class_eval do
    # Support STI models with common route_path_segment option
    def type_scope
      publishable_config[:class].base_class.all
    end
  end
end
