User.delete_all

User.create(
  email: 'user@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 0
)

User.create(
  email: 'seller@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 1
)

User.create(
  email: 'admin@vroom.com',
  password: 'password',
  password_confirmation: 'password',
  role: 2
)
