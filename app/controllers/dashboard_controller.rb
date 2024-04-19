class DashboardController < ApplicationController
  before_action :require_admin_or_seller, only: [:index, :cars, :bookings]
  before_action :require_admin, only: [:users]

  def index
    load_cars_and_bookings
  end

  def cars
    load_cars
  end

  def users
    @users = User.all
  end

  def bookings
    load_bookings
  end

  private

  def load_cars_and_bookings
    if current_user.admin?
      @cars = Car.all
      @bookings = Booking.all
    else
      @cars = current_user.cars
      @bookings = Booking.joins(:car).where(cars: { user_id: current_user.id })
    end
  end

  def load_cars
    @cars = current_user.admin? ? Car.all.except(:image) : current_user.cars
  end

  def load_bookings
    @bookings = if current_user.admin?
                  Booking.all.order(created_at: :asc)
                else
                  Booking.joins(:car).where(cars: { user_id: current_user.id }).order(updated_at: :desc)
                end
  end

  def require_admin_or_seller
    routing_exception unless current_user.seller_or_admin?
  end

  def require_admin
    routing_exception unless current_user.admin?
  end
end
