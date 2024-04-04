class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]
  before_action :set_car, only: %i[ new index ]
  before_action :check_user_bookings, only: %i[ create ]
  before_action :verify_corrent_user, only: %i[ show edit update destroy ]

  def show
  end

  def new
    @booking = Booking.new
  end

  def edit
  end

  def create
    @booking = current_user.bookings.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.turbo_stream
      else
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy!

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Booking Removed!" }
    end
  end

  private

  def check_user_bookings
    car_id = params[:booking][:car_id]
    if current_user.bookings.exists?(car_id: car_id)
      redirect_to cars_path, notice: "You've already requested to book this car."
    end
  end

  def verify_corrent_user
    routing_exception unless current_user.id == @booking.car.user.id || current_user.admin?
  end

  def set_car
    @car = Car.find(params[:car_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :pickup_location, :drop_location, :status, :comment, :car_id)
  end
end
