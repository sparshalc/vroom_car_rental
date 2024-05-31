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

    @booked_by_user = current_user.bookings.where(status: "accepted").exists?(car_id: @car.id)
  end

  def new
    @car = Car.new
  end

  def edit
  end

  def create
    @car = Car.new(car_params)

    if @car.save
      redirect_to dashboard_cars_path, notice: 'Car added successfully!'
    else
      render :new, status: :unprocessable_entity
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
    if @car.update(car_params)
      redirect_to dashboard_cars_path, notice: 'Car updated successfully!'
    else
      format.json { render json: @car.errors,status: :unprocessable_entity }
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
      params.require(:car).permit(:brand,
      :name,
      :model,
      :color,
      :mileage,
      :availability,
      :location,
      :rental_price,
      :insurance,
      :car_type,
      :user_id,
      :description,
      image: [])
    end

    def verify_corrent_user
      routing_exception unless current_user.id == @car.user_id || current_user.admin?
    end

    def verify_seller_or_admin
      routing_exception unless current_user.seller_or_admin?
    end
end
