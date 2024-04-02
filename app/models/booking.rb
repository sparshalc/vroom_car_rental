class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  after_create_commit { update_duration }
  after_update_commit { update_avaibility }

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  def duration_in_days
    "#{self.duration} days"
  end

  private

  def update_avaibility
    self.accepted? ? self.car.update(availability: false) : self.car.update(availability: true)
  end

  def update_duration
    self.update(duration: calculate_duration)
  end

  def calculate_duration
    return unless start_date || end_date

    time_in_seconds = (self.end_date - self.start_date).to_f
    time_in_days = (time_in_seconds / (24 * 60 * 60)).round(1)
  end

end
