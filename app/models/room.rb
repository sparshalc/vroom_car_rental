class Room < ApplicationRecord
  after_create_commit { broadcast_prepend_to "rooms" }
  after_update_commit { broadcast_update_to "rooms" }
  after_destroy_commit { broadcast_remove_to "rooms" }

  has_many :messages, dependent: :destroy

  belongs_to :user
  belongs_to :car

  validates :name, presence: true
end
