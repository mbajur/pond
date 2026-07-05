class SearchesController < ApplicationController
  skip_after_action :verify_authorized, only: [ :show ]

  def show
    @query = params[:q]
    @collections = policy_scope(Collection).search(@query).includes(:user).limit(3)
    @posts = policy_scope(Post).search(@query).includes(:user, :thumb_attachment).limit(24)

    add_breadcrumb "Search results for '#{@query}'", search_path(q: @query)

    render Views::Searches::Show.new(query: @query, collections: @collections, posts: @posts)
  end
end
