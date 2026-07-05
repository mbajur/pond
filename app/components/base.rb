# frozen_string_literal: true

class Components::Base < Phlex::HTML
  include RubyUI
  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes

  register_value_helper :current_user
  register_value_helper :authenticated?
  register_value_helper :policy
  register_value_helper :marksmithed

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end

  private

  # I had to overwrite the default rails helper to be able render that partial outside of a view context.
  # Is there a better way to do this?
  def rails_blob_path(variant)
    if ENV["CDN_HOST"].present?
      Rails.application.routes.url_helpers.rails_storage_proxy_url(variant, host: ENV["CDN_HOST"])
    else
      Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
    end
  end

  def timeago(date, format: :long)
    return if date.blank?

    content = I18n.l(date, format: format)

    time(
      title: content,
      data: {
        controller: "timeago",
        timeago_datetime_value: date.iso8601
      }
    ) { content }
  end

  def cache_store
    Rails.cache
  end
end
