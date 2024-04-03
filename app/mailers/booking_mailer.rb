class BookingMailer < ApplicationMailer

  def new_booking(booking, user)
    @user = user
    @booking = booking

    mail(
      to: user.email,
      subject: "Booking Request for #{booking.car.name}."
    )
  end
end
