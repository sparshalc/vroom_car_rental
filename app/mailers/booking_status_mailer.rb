class BookingStatusMailer < ApplicationMailer

  def booking_status(booking)
    @booking = booking

    mail(
      to: booking.user.email,
      subject: "Reqest #{booking.status} for #{booking.car.name}"
    )
  end
end
