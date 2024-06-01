class FeedbackMailer < ApplicationMailer
  def new_feedback(full_name,admin_email)
    @full_name = full_name
    @admin_email = admin_email

    mail(
      to: admin_email,
      subject: 'Feedback Received'
    )
  end
end
