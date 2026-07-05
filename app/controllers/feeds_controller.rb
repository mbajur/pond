class FeedsController < ApplicationController
  before_action :authenticate_user!

  skip_after_action :verify_authorized

  def show
    @page_title = "Feed"
    add_breadcrumb("Feed", feed_path)

    @collections = policy_scope(
      Collection.joins(:user)
                .where(users: { id: current_user.following_users.pluck(:id) + [ current_user.id ] })
                .or(Collection.where(id: current_user.following_collections.pluck(:id)))
                .where(pins_count: 1..)
                .order(changed_at: :desc)
                .includes(:user)
                .limit(20)
    )

    render Views::Feeds::Index.new(collections: @collections, opts: { show_collection_author: true })
  end
end
