class CollectionsController < ApplicationController
  before_action :authenticate_user!, only: %i[update destroy]

  def index
    ensure_public_profile!
    authorize Collection

    add_breadcrumb(find_user.to_s, user_path(find_user))

    @page_title = "Collections by #{find_user}"
    @collections = policy_scope(find_user.collections).regular.all.recently_changed_first
    @inbox = policy_scope(find_user.collections).find_inbox

    render Views::Collections::Index.new(collections: @collections, inbox: @inbox, user: find_user)
  end

  def show
    ensure_public_profile!
    @collection = find_collection
    authorize @collection

    add_breadcrumb(find_user.to_s, user_path(find_user))
    add_breadcrumb(@collection.name, user_collection_path(@collection.user, @collection))

    set_meta_tags @collection
    @pagy, @pins = pagy(policy_scope(@collection.pins.order(id: :desc).includes(:user, pinable: [ :screenshot_attachment, :thumb_attachment ])))

    Current.collection = @collection

    render Views::Collections::Show.new(collection: @collection, pins: @pins, pagy: @pagy)
  end

  def create
    @collection = Collection.new(collection_params)
    authorize @collection

    @collection.user = current_user

    respond_to do |format|
      format.turbo_stream do
        if @collection.save
          redirect_to user_collection_path(@collection.user, @collection), notice: "Collection created"
        else
          render turbo_stream: turbo_stream.replace("collection_form", text: "xxx")
        end
      end
    end
  end

  def update
    @collection = policy_scope(current_user.collections).find_by_slug!(params[:slug])
    authorize @collection

    respond_to do |format|
      format.turbo_stream do
        if @collection.update(collection_params)
          redirect_to user_collection_path(@collection.user, @collection), notice: "Collection updated"
        else
          render turbo_stream: turbo_stream.replace("collection_form", text: "xxx")
        end
      end
    end
  end

  def pin
    @pin = Pin.new
    @collection = policy_scope(Collection).find(params[:id])
    authorize @collection, :connect?

    render Views::Pins::New.new(pin: @pin, pinable: @collection)
  end

  def destroy
    @collection = policy_scope(current_user.collections).find_by_slug!(params[:slug])
    authorize @collection

    @collection.destroy!

    redirect_to user_path(current_user), notice: "Collection deleted"
  end

  private

  def collection_params
    params.require(:collection).permit(:name, :description, :private)
  end

  def find_user
    @find_user ||= User.find_by_username!(params[:user_id])
  end

  def find_collection
    @find_collection ||= policy_scope(find_user.collections).find_by_slug!(params[:slug])
  end

  def ensure_public_profile!
    if find_user.private? && (!authenticated? || current_user.id != find_user.id)
      raise UserProfileIsPrivateError.new("This user's profile is private.")
    end
  end
end
