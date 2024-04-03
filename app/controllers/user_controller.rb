class UserController < ApplicationController
  def bookings
    @bookings = current_user.bookings.all
  end

end
