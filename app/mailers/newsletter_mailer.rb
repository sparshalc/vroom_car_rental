class NewsletterMailer < ApplicationMailer
  def subscribed_to_newsletter(user)
    @user = user
    mail(
      to: user.email,
      subject: "Welcome to VROM's Newsletter Community!"
    )
  end
end
