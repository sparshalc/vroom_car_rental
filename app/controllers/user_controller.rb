class UserController < ApplicationController
  def bookings
    @bookings = current_user.bookings.all
  end

  def subscribe_to_newsletter
    current_user.update(subscribed_to_newsletter: true)
    NewsletterMailer.subscribed_to_newsletter(current_user).deliver_now

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Congratulations! #{current_user.full_name}. You are now subscribed to Vroom's Newsletter 📰" }
    end
  end
end
