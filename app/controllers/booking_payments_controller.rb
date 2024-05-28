class BookingPaymentsController < ApplicationController
  def create
    @car = Car.find(params[:car_id])

    stripe_price = Stripe::Price.create({
      currency: 'inr',
      unit_amount: Money.from_amount(BigDecimal(booking_payments_params[:total_amount])).cents,
      product_data: {
        name: @car.name
      },
    })

    success_url = url_for(
      controller: 'booking_payments',
      action: 'success',
      only_path: false,
      booking_params: booking_payments_params.except(:stripeToken)
    )

    stripe_session = Stripe::Checkout::Session.create({
      success_url: success_url,
      line_items: [
        {
          price: stripe_price.id,
          quantity: 1,
        },
      ],
      mode: 'payment',
    })

    redirect_to stripe_session.url, allow_other_host: true, status: 303
  end

  def success
    booking_params = params[:booking_params]
    car = Car.find(booking_params[:car_id])
    reservation = Booking.create!(
      user_id: current_user.id,
      car_id: booking_params[:car_id],
      start_date: booking_params[:start_date],
      end_date: booking_params[:end_date],
      comment: booking_params[:comment],
      pickup_location: booking_params[:pickup_location],
      drop_location: booking_params[:drop_location]
    )

    Payment.create!(
      name: "Payment for #{car.name}",
      booking_id: reservation.id,
      base_fare: Money.from_amount(BigDecimal(booking_params[:base_fare])).to_i,
      service_fee: Money.from_amount(BigDecimal(booking_params[:service_fee])).to_i,
      total_amount: Money.from_amount(BigDecimal(booking_params[:total_amount])).to_i,
    )

    redirect_to payment_success_path
  end

  private

  def booking_payments_params
    params.permit(
      :car_id,
      :user_id,
      :start_date,
      :end_date,
      :comment,
      :drop_location,
      :pickup_location,
      :base_fare,
      :total_amount,
      :service_fee
    )
  end
end
