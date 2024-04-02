class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]
  before_action :set_car, only: %i[ new index ]

  def index
    @bookings = Booking.all
  end

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
      format.html { redirect_to car_bookings_path, notice: "Booking was successfully destroyed." }
    end
  end

  private

    def set_car
      @car = Car.find(params[:car_id])
    end

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(:start_date, :end_date, :pickup_location, :drop_location, :status, :comment, :duration, :car_id)
    end
end
