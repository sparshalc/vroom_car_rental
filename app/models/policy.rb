class Policy < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :title, presence: true

end
