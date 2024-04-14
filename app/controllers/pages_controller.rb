class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def home
    @car = Car.limit(3)
  end

  def guides; end
end
