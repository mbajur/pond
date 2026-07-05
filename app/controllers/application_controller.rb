class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Method

  include Authentication
  include Breadcrumbable

  class UserProfileIsPrivateError < StandardError; end

  rescue_from UserProfileIsPrivateError, with: :handle_user_profile_is_private

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  after_action :verify_authorized, except: [ :root ]

  def root
    if authenticated?
      redirect_to feed_path
    else
      redirect_to join_path
    end
  end

  private

  def pundit_user
    resume_session && current_user
  end

  def handle_user_profile_is_private
    redirect_to root_path
  end

  def preload_user_collections_for_select
    Current.collections_for_select ||= begin
      if authenticated?
        current_user.collections.order(name: :asc).select(:id, :name).to_a
      else
        []
      end
    end
  end
end
