class Car < ApplicationRecord
  belongs_to :user

  has_many :comments,dependent: :destroy
  has_many :policies,dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :payments, through: :bookings, dependent: :destroy

  has_rich_text :description

  has_many_attached :image

  after_create_commit :create_default_policies

  validates :brand, :model, :mileage, :location, :name, :description, presence: true
  validates :rental_price, presence: true, numericality: {greater_than_or_equal_to: 0}

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

  def create_default_policies
    Policy.create(title: 'Non-Refundable', car_id: id, user_id: user.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["availability", "brand", "color", "created_at", "id", "id_value", "image", "insurance", "location", "mileage", "model", "name", "rental_price", "car_type", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "image_attachment", "image_blob", "user"]
  end

  def is_available?
    return self.update(availability: false) && 'booked' if self.booked?
    return self.update(availability: true) && 'available' if self.is_rejected? || self.is_pending?

    self.availability ? 'available' : 'not-available'
  end

  def booked?
    bookings.where(status: 'accepted').present?
  end

  def is_rejected?
    bookings.where(status: 'rejected').present?
  end

  def is_pending?
    bookings.where(status: 'pending').present?
  end

  def price
    "Rs. #{self.rental_price.to_i}/day"
  end

  def mileage_in_km
    "#{self.mileage} km/hr"
  end
end
