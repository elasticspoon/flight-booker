FactoryBot.define do
  factory :flight do
    association :arrival_airport, factory: :airport
    association :departure_airport, factory: :airport
    departure { Faker::Date.forward(days: 999).to_datetime }
    duration { rand(3600..86_400) }
  end
end
