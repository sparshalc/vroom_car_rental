class DashboardController < ApplicationController
  before_action :verify_admin_or_seller, only: %i[index cars]

  def index
    if current_user.admin?
      @cars = Car.all
    else
      @cars = current_user.cars
    end
  end

  def cars
    if current_user.admin?
      @cars = Car.all
    else
      @cars = current_user.cars.all
    end
  end

  private
  def verify_admin_or_seller
    raise ActionController::RoutingError.new('Routing Error') unless current_user.seller_or_admin?
  end
end
