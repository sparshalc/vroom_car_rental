class Car < ApplicationRecord
  belongs_to :user

  has_many :comments,dependent: :destroy
  has_many :policies,dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :payments, through: :bookings, dependent: :destroy
  has_many :room

  has_rich_text :description

  has_many_attached :image

  after_create_commit :create_default_policies, :create_room, :create_default_message

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

  def create_room
    Room.create(name: "#{name} Enquiry", car_id: id, user_id: user.id )
  end

  def create_default_message
    Message.create(user_id: user.id, room_id: room.first.id, content: "Welcome to #{name} Help Center! Do you need any assistance getting started with #{name}?")
  end

  def self.ransackable_attributes(auth_object = nil)
    ["availability", "brand", "color", "created_at", "id", "id_value", "image", "insurance", "location", "mileage", "model", "name", "rental_price", "car_type", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "image_attachment", "image_blob", "user"]
  end

  def is_available?
    return update(availability: false) && 'booked' if booked?
    return update(availability: true) && 'available' if is_rejected? || is_pending?

    availability ? 'available' : 'not-available'
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
    "Rs. #{rental_price.to_i}/day"
  end

  def mileage_in_km
    "#{mileage} km/hr"
  end
end
