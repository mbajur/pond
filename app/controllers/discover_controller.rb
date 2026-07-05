class DiscoverController < ApplicationController
  before_action :authenticate_user!

  skip_after_action :verify_authorized

  def show
    @page_title = "Discover"
    add_breadcrumb("Discover", discover_path)

    @collections = policy_scope(
      Collection.joins(:user)
                .where(pins_count: 1..)
                .where.not(private: true)
                .order(changed_at: :desc)
                .includes(:user)
                .limit(20)
    )

    render Views::Discover::Index.new(collections: @collections, opts: { show_collection_author: true })
  end
end
