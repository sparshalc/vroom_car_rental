User.delete_all

User.create(
  email: 'user@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 0,
  phone_number: '9845454545',
  full_name: 'VROOM USER'
)

User.create(
  email: 'seller@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 1,
  phone_number: '9845454545',
  full_name: 'VROOM SELLER'
)

User.create(
  email: 'admin@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 2,
  phone_number: '9845454545',
  full_name: 'VROOM ADMIN'
)
