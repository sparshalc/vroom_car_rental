class NewBookingJob < ApplicationJob
  queue_as :default

  def perform(booking, user)
    BookingMailer.new_booking(booking, user).deliver_now
  end
end
