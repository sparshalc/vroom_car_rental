class DashboardController < ApplicationController
  before_action :verify_admin_or_seller, only: %i[index]

  def index
    @cars = Car.all
  end

  private
  def verify_admin_or_seller
    raise ActionController::RoutingError.new('Routing Error') unless current_user.seller_or_admin?
  end
end
