class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  enum role: { user: 0, seller: 1, admin: 2 }

  validate :avatar_content_type, if: :avatar_attached?
  validates :full_name, presence: true, uniqueness: { message: "has already been taken try again with a new one." }
  validate :phone_number_format

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
