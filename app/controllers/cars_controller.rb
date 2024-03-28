class CarsController < ApplicationController
  before_action :set_car, only: %i[ show edit update destroy ]
  before_action :verify_seller_or_admin, except: %i[show index ]
  before_action :verify_corrent_user,only: %i[edit update destroy]

  def index
    @q = Car.ransack(params[:q])
    @cars = @q.result(distinct: true)
  end

  def show
    @comments = @car.comments.all
    @car.update(views: @car.views + 1)
  end

  def new
    @car = Car.new
  end

  def edit
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
      params.require(:car).permit(:brand, :name, :model, :color, :mileage, :availability, :location, :rental_price, :insurance, :car_type, :image, :user_id)
    end

    def verify_corrent_user
      routing_exception unless current_user.id == @car.user_id || current_user.admin?
    end

    def verify_seller_or_admin
      routing_exception unless current_user.seller_or_admin?
    end
end
