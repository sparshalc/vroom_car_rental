class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car
  has_one :payment, dependent: :destroy

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  scope :upcoming_bookings, -> { where("start_date > ?", Date.today).order(:start_date) }
  scope :current_bookings, -> { where("end_date > ?", Date.today).where("start_date < ?", Date.today).order(:checkout_date) }

  after_create_commit :send_booking_mail
  after_update_commit :update_availability, :check_booking_status, :send_booking_status_mail
  after_destroy_commit :update_availability

  def send_booking_mail
    users_to_notify = [car.user]
    users_to_notify << User.where(role: "admin") unless user == car.user
    users_to_notify.flatten.uniq.each do |recipient|
      NewBookingJob.perform_now(self, recipient)
    end
  end

  def send_booking_status_mail
    if (booking_accepted? || booking_rejected?)
      BookingStatusJob.perform_now(self)
    end
  end

  def duration_in_days
    "#{(end_date - start_date).to_f} days"
  end

  private

  def check_booking_status
    update(status: :rejected) if accepted? && car.bookings.accepted.count > 1
  end

  def update_availability
    return car.update(availability: true) unless self.persisted? || self.booking_rejected?

    car.update(availability: !accepted?)
  end

  def booking_accepted?
    status == "accepted"
  end

  def booking_rejected?
    status == "rejected"
  end
end
