class Cars::CoverImagesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!
  before_action :set_car

  def destroy
    @car.image.purge_later
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.remove(dom_id(@car, :cover_image)),
          turbo_stream.update("remove_all_image")
        ]
      }
      format.html { redirect_to edit_car_path(@car) }
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end
end
