User.delete_all
Car.delete_all

User.create(
  email: 'user@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 0,
  phone_number: '9845454545',
  full_name: 'VROOM USER',
  location: 'Bharatpur-10, Chitwan',
  subscribed_to_newsletter: false,
  verified: false
)

User.create(
  email: 'seller@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 1,
  phone_number: '9845454545',
  full_name: 'VROOM SELLER',
  location: 'Bharatpur-10, Chitwan',
  subscribed_to_newsletter: false,
  verified: false
)

User.create(
  email: 'admin@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 2,
  phone_number: '9845454545',
  full_name: 'VROOM ADMIN',
  location: 'Bharatpur-10, Chitwan',
  subscribed_to_newsletter: false,
  verified: false
)

10.times do
  c = Car.new(
    brand: Faker::Vehicle.make,
    name: Faker::Vehicle.model,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    model: Faker::Vehicle.model,
    color: Faker::Vehicle.color,
    mileage: Faker::Vehicle.mileage,
    availability: Faker::Boolean.boolean,
    location: Faker::Address.city,
    rental_price: Faker::Number.between(from: 500, to: 1000),
    insurance: Faker::Boolean.boolean,
    car_type: Car.car_types.keys.sample,
    user_id: User.last.id
  )

  image_file = UnsplashImage.tempfile(size: '500x500', tags: 'car')
  c.image.attach(io: image_file, filename: 'image.jpg', content_type: 'image/jpeg')

  c.save!
end
