class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :redirect_to_error_page

  before_action :authenticate_user!

  private

  def routing_exception
    raise ActionController::RoutingError.new('Routing Error')
  end

  def redirect_to_error_page(exception)
    redirect_to '/404.html'
  end
end
