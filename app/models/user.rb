class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :invitable

  has_one_attached :avatar

  has_many :policies, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :cars, dependent: :destroy
  has_many :payments, through: :bookings, dependent: :destroy
  has_many :notifications, as: :recipient

  enum role: { user: 0, seller: 1, admin: 2 }

  validate :avatar_content_type, if: :avatar_attached?
  validates :location, presence: true
  validates :full_name, presence: true, uniqueness: { message: "has already been taken try again with a new one." }
  validate :phone_number_format

  def seller_or_admin?
    self.admin? || self.seller?
  end

  private

  def phone_number_format
    unless phone_number =~ /^\d{10}$/
      errors.add(:phone_number, "must be 10 digits")
    end
  end

  def avatar_content_type
    unless valid_content_type.include?(avatar.blob.content_type)
      errors.add(:avatar, "Invalid file format. Plese select avatar with (JPEG/PNG) format.")
    end
  end

  def valid_content_type
    %w(image/jpeg image/png)
  end

  def avatar_attached?
    avatar.attached?
  end

end
