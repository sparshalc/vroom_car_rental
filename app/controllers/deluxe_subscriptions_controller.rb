class DeluxeSubscriptionsController < ApplicationController
  def create
    @user = User.find(params[:user_id])

    stripe_price = Stripe::Price.create({
      currency: 'inr',
      unit_amount: Money.from_amount(BigDecimal(deluxe_subscriptions_params[:total_amount])).cents,
      product_data: {
        name: @user.full_name
      },
    })

    success_url = url_for(
      controller: 'deluxe_subscriptions',
      action: 'success',
      only_path: false,
      booking_params: deluxe_subscriptions_params.except(:stripeToken)
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
    current_user.update(verified: true)

    redirect_to payment_success_path
  end

  private

  def deluxe_subscriptions_params
    params.permit(
      :user_id,
      :total_amount
    )
  end
end
