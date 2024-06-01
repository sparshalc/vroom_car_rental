class Feedback < ApplicationRecord
  belongs_to :user

  validates :name, :email, presence: true
  validates :message, length: {minimum: 10, maximum: 500}, allow_blank: false
end
