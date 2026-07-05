class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :create_url, :create_text, :create_image ]

  def show
    post = policy_scope(Post).find(params[:id])
    authorize post

    @page_title = post.title.presence || "Untitled"
    @page_description = post.description

    pins = policy_scope(Pin)
      .where(pinable: post)
      .includes(:user, collection: [ :user ])
      .limit(10)
      .order(created_at: :desc)

    render Views::Posts::Show.new(post: post, pins: pins)
  end

  # GET /pins/new
  def new_text
    post = Post::Text.new(create_text_params)
    authorize post, :new?

    render Views::Posts::NewText.new(post: post)
  end

  def new_url
    post = Post::Url.new(create_url_params)
    authorize post, :new?

    render Views::Posts::NewUrl.new(post: post)
  end

  def new_image
    post = Post::Image.new(create_image_params)
    authorize post, :new?

    render Views::Posts::NewImage.new(post: post)
  end

  def edit_text
    post = policy_scope(Post).find(params[:id])
    authorize post, :edit?

    render Views::Posts::Edit.new(post: post)
  end

  def context_menu
    @post = policy_scope(Post).find(params[:id])
    authorize @post

    render Views::Posts::ContextMenu.new(post: @post)
  end

  def update_text
    @referrer_action = Rails.application.routes.recognize_path(request.referer)
    @post = policy_scope(Post).find(params[:id])
    authorize @post

    if @post.update(create_text_params.except(:collection_id))
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render :update_text, status: :unprocessable_entity }
      end
    end
  end

  def create_url
    @referrer_action = Rails.application.routes.recognize_path(request.referer)

    Post.transaction do
      @post = Post.new(create_url_params.except(:collection_id))
      @post.user = current_user
      @post.save if @post.new_record?

      @pin = Pin.new
      @pin.pinable = @post
      @pin.user = current_user

      @collection = current_user.collections.find_by(id: create_url_params[:collection_id]) || current_user.collections.find_inbox!
      @pin.collection = @collection

      authorize @pin, :create?
    end

    if @pin.save!
      UrlThumbnailer::FetchMetaJob.perform_later(@post)
      @collection.touch(:changed_at)

      respond_to do |format|
        format.turbo_stream { render :create }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  def create_text
    @referrer_action = Rails.application.routes.recognize_path(request.referer)

    @post = Post::Text.new(create_text_params.except(:collection_id))
    @post.user = current_user
    @post.save

    @pin = Pin.new
    @pin.pinable = @post
    @pin.user = current_user
    @collection = current_user.collections.find_by(id: create_text_params[:collection_id]) || current_user.collections.find_inbox!
    @pin.collection = @collection

    authorize @pin, :create?

    if @pin.save!
      @collection.touch(:changed_at)

      respond_to do |format|
        format.turbo_stream { render :create }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  def create_image
    @referrer_action = Rails.application.routes.recognize_path(request.referer)

    @post = Post::Image.new(create_image_params.except(:collection_id))
    @post.user = current_user
    @post.title = params.dig(:post_image, :files)&.last&.original_filename.to_s
    @post.save

    @pin = Pin.new
    @pin.pinable = @post
    @pin.user = current_user
    @collection = current_user.collections.find_by(id: create_image_params[:collection_id]) || current_user.collections.find_inbox!
    @pin.collection = @collection

    authorize @pin, :create?

    if @pin.save!
      @collection.touch(:changed_at)

      respond_to do |format|
        format.turbo_stream { render :create }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  private

  def create_text_params
    params.require(:post_text).permit(:content, :collection_id)
  end

  def create_url_params
    params.require(:post_url).permit(:url, :collection_id)
  end

  def create_image_params
    params.require(:post_image).permit(:collection_id, files: [])
  end
end
