class DashboardController < ApplicationController
  before_action :verify_admin_or_seller, only: %i[index cars bookings]
  before_action :verify_admin, only: %i[users]
  before_action :car_collection, only: %i[index]

  def index
  end

  def cars
    if current_user.admin?
      @cars = Car.all
    else
      @cars = current_user.cars.all
    end
  end

  def users
    @users = User.all
  end

  def bookings
    if current_user.admin?
      @bookings = Booking.all.order('Created_at ASC')
    else
      @bookings = Booking.joins(:car).where(cars: { user_id: current_user.id }).order("Updated_at DESC")
    end
  end


  private

  def total_cars
    if current_user.admin?
      @cars = Car.all
    else
      @cars = current_user.cars
    end
  end

  def car_collection
    @cars = Car.all
  end

  def verify_admin_or_seller
    routing_exception unless current_user.seller_or_admin?
  end

  def verify_admin
    routing_exception unless current_user.admin?
  end
end
