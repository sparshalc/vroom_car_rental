class BookingMailer < ApplicationMailer

  def new_booking(booking, user)
    @user = user
    @booking = booking
    @duration = (booking.end_date - booking.start_date).to_f

    mail(
      to: user.email,
      subject: "Booking Request for #{booking.car.name}."
    )
  end
end
