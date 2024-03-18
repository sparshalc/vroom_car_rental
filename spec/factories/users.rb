FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    password { "password" }
    password_confirmation { "password" }
    role { 0 }
    avatar { }
    phone_number { '1234567891' }
  end
  factory :seller, parent: :user do
    role { 1 }
    status { "seller" }
  end
  factory :avatar, parent: :user do
  end
end
