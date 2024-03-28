class DashboardController < ApplicationController
  before_action :verify_admin_or_seller, only: %i[index cars]
  before_action :verify_admin, only: %i[users]
  before_action :total_cars, only: %i[index cars]

  def index
  end

  def cars
  end

  def users
    @users = User.all
  end

  private

  def total_cars
    if current_user.admin?
      @cars = Car.all
    else
      @cars = current_user.cars
    end
  end

  def verify_admin_or_seller
    routing_exception unless current_user.seller_or_admin?
  end

  def verify_admin
    routing_exception unless current_user.admin?
  end
end
