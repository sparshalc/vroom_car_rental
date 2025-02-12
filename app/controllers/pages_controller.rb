class PagesController < ApplicationController
  skip_before_action :authenticate_user!, except: %i[calendar]
  before_action :authenticate_user!, only: %i[payment_success calendar]
  def home
    @car = Car.limit(3)
  end

  def guides; end

  def pricing; end

  def payment_success; end

  def calendar
    routing_exception unless current_user.verified?

    @events = Booking.where("start_date >= ?", Date.today)
    start_date = params.fetch(:start_date, Date.today).to_date
    if current_user.admin?
      @bookings = Booking.where(start_date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
    else
      @bookings = current_user.bookings.where(start_date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
    end
  end

  def bookings
    if format_turbo_stream
      @booking = Booking.find(params[:id])
    else
      routing_exception
    end
  end
end
