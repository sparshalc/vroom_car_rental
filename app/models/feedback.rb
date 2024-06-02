class Feedback < ApplicationRecord
  belongs_to :user

  validates :name, :email, presence: true
  validates :message, length: {minimum: 10, maximum: 500}, allow_blank: false

  after_create_commit :notify_admins

  def notify_admins
    User.admin.each do |admin|
      FeedbackMailer.new_feedback(name, admin.email).deliver_now
    end
  end

  def status
    private ? 'Private' : 'Public'
  end
end
