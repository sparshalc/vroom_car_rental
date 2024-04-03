class BookingStatusJob < ApplicationJob
  queue_as :default

  def perform(booking)
    BookingStatusMailer.booking_status(booking).deliver_now
  end
end
