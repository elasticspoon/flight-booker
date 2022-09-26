FactoryBot.define do
  factory :airport do
    location { "#{Faker::Address.city}, #{Faker::Address.country}" }
    code { Faker::Address.country_code_long }
  end
end
