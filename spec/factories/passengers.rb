FactoryBot.define do
  factory :passenger do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    booking
  end
end
