class PinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pin, only: %i[ update_collection destroy ]
  before_action :preload_user_collections_for_select

  def new
    @pin = Pin.new
    @pinable = find_pinable
    authorize @pinable, :connect?

    render Views::Pins::New.new(pin: @pin, pinable: @pinable)
  end

  def create
    @pinable = find_pinable
    @referrer_action = Rails.application.routes.recognize_path(request.referer)
    target_collection = policy_scope(current_user.collections).find(pin_params[:collection_id])
    @pin = Pin.new(collection: target_collection)
    authorize @pin

    @pin.pinable = @pinable
    @pin.user = current_user

    if @pin.save
      @pin.collection.touch(:changed_at)

      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  def secondary_actions
    @pin = policy_scope(Pin).find(params[:id])
    authorize @pin

    render Views::Pins::SecondaryActions.new(pin: @pin)
  end

  def destroy
    authorize @pin
    @pin.destroy!

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "Pin was successfully destroyed." }
      format.turbo_stream
    end
  end

  private

  def set_pin
    @pin = Pin.find(params[:id])
  end

  def pin_params
    params.require(:pin).permit(:collection_id, pinable_attributes: [ :url ])
  end

  def find_pinable
    if params[:post_id]
      @pinable = policy_scope(Post).find(params[:post_id])
    elsif params[:collection_slug]
      @pinable = policy_scope(Collection).find_by_slug!(params[:collection_slug])
    else
      raise ActiveRecord::RecordNotFound, "Pinable not found"
    end
  end
end
