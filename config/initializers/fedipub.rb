require "fediverse/inbox"

Fedipub.config_from "fedipub"

if Rails.env.production?
  Fedipub.configure do |config|
    config.site_host = "https://#{Figaro.env.host}"
    config.open_registrations = false
  end
end

Rails.application.config.after_initialize do
  Fediverse::Inbox.register_handler("Like", "*", Fedipub::LikeActivityHandler, :handle_like_activity)
end

# Monkey patches
Rails.application.config.to_prepare do
  Fedipub::ServerController.class_eval do
    include Authentication

    private

    def pundit_user
      resume_session && current_user
    end
  end

  Fedipub::Server::PublishedController.class_eval do
    def show
      @publishable = type_scope.find_by!(url_param => params[:id])

      entity_config = Fedipub.data_entity_configuration(@publishable.class)
      if entity_config[:soft_deleted_method] && @publishable.send(entity_config[:soft_deleted_method])
        raise Fedipub::DataEntity::TombstonedError
      end

      authorize @publishable, policy_class: Fedipub::Server::PublishablePolicy
    end

    private

    # Support STI models with common route_path_segment option
    def type_scope
      publishable_config[:class].base_class.all
    end
  end

  # Same STI + type mismatch fix as above, for incoming federation lookups (Fedipub::Utils::Object.from_local_route)
  def Fedipub.data_entity_handled_on(route_path_segment)
    route_path_segment = route_path_segment.to_s

    config = Fedipub::Configuration.data_types.values.find { |v| v[:route_path_segment].to_s == route_path_segment }
    return nil unless config

    config.merge(class: config[:class].base_class)
  end
end
