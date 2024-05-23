class BookingsController < ApplicationController
  before_action :set_booking, only: %i[edit update destroy]
  before_action :set_car, only: %i[new create]
  before_action :check_params, only: %i[new]
  before_action :check_user_bookings, only: %i[new create]
  before_action :verify_correct_user, only: %i[edit update destroy]

  def edit
  end

  def new
    if params[:start_date].present? && params[:end_date].present?
      initialize_booking_variables
    end
  end

  def create
    @booking = current_user.bookings.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.turbo_stream
      else
        redirect_to root_path, alert: @booking.errors.full_messages.join(', ')
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
    @booking.destroy
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Booking Cancelled" }
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_car
    @car = Car.find(params[:car_id])
  end

  def check_user_bookings
    if current_user.bookings.exists?(car_id: @car.id)
      redirect_to car_path(@car), notice: "You've already requested to book this car."
    end
  end

  def verify_correct_user
    unless current_user.admin? || current_user == @booking.user || current_user == @booking.car.user
      routing_exception
    end
  end

  def initialize_booking_variables
    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])
    @pickup_location = params[:pickup_location]
    @drop_location = params[:drop_location]
    @comment = params[:comment]

    @total_nights = (@end_date - @start_date).to_i
    @per_night = @car.rental_price
    @base_fare = @per_night * @total_nights
    @service_fee = current_user.verified ? 0 : @base_fare * 0.1
    @total_amount = @base_fare + @service_fee

    @booking = Booking.new
  end

  def check_params
    if params[:start_date].blank? && params[:end_date].blank?
      routing_exception
    end
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :pickup_location, :drop_location, :status, :comment, :car_id)
  end
end
