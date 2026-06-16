# frozen_string_literal: true

class Components::Base < Phlex::HTML
  include RubyUI
  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::Sanitize

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

  # @todo it still converts <h3><a>test</a></h3> to <a></a>test, fix that
  def marksmithed_minimal(text, opts = {})
    body = marksmithed(text)
    sanitize(body, tags: %w[p a strong em],
                   attributes: %w[rel href])
  end

  def cache_store
    Rails.cache
  end
end
