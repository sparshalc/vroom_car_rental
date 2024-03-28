class Car < ApplicationRecord
  belongs_to :user

  has_many :comments,dependent: :destroy
  has_many :policies,dependent: :destroy
  has_one_attached :image

  enum car_type: {
    sedan: 0,
    suv: 1,
    coupe: 2,
    convertible: 3,
    hatchback: 4,
    station_wagon: 5,
    minivan: 6,
    truck: 7,
    electric_vehicle: 8,
    hybrid_vehicle: 9
  }

  def self.ransackable_attributes(auth_object = nil)
    ["availability", "brand", "color", "created_at", "id", "id_value", "image", "insurance", "location", "mileage", "model", "name", "rental_price", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "image_attachment", "image_blob", "user"]
  end

  def is_available?
    self.availability ? 'available' : 'not-available'
  end

end
