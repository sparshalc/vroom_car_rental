class CarsController < ApplicationController
  before_action :set_car, only: %i[ show edit update destroy share]
  before_action :verify_seller_or_admin, except: %i[show index share]
  before_action :verify_corrent_user,only: %i[edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @q = Car.ransack(params[:q])
    @cars = @q.result(distinct: true).order('Created_at DESC')
  end

  def show
    @booking = current_user.bookings.build
    @comments = @car.comments.all
    @car.update(views: @car.views + 1)

    upcoming_reservations = @car.bookings.upcoming_bookings.pluck(:start_date, :end_date)
    @blocked_dates = upcoming_reservations.map { |reservation| [reservation[0].to_s, (reservation[1] - 1.day).to_s] }

    @car_booked_by_current_user = current_user.bookings.exists?(car_id: @car.id)
  end

  def new
    if format_turbo_stream
      @car = Car.new
    else
      routing_exception
    end
  end

  def edit
    if format_turbo_stream
    else
      routing_exception
    end
  end

  def create
    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        format.turbo_stream
      else
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def share
    @share_url = car_url(@car)
    if format_turbo_stream
    else
      routing_exception
    end
  end

  def update
    respond_to do |format|
      if @car.update(car_params)
        format.turbo_stream
      else
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @car.destroy!

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

    def set_car
      @car = Car.find(params[:id])
    end

    def car_params
      params.require(:car).permit(:brand, :name, :model, :color, :mileage, :availability, :location, :rental_price, :insurance, :car_type, :user_id, image: [])
    end

    def verify_corrent_user
      routing_exception unless current_user.id == @car.user_id || current_user.admin?
    end

    def verify_seller_or_admin
      routing_exception unless current_user.seller_or_admin?
    end

    def format_turbo_stream
      request.headers['Accept']&.include?('text/vnd.turbo-stream.html')
    end
end
