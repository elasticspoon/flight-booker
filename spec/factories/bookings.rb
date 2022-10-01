FactoryBot.define do
  factory :booking do
    flight
  end
end

def create_booking_with_passengers(passenger_count: 2)
  FactoryBot.create(:booking) do |booking|
    FactoryBot.create_list(:passenger, passenger_count, booking:)
  end
end

def build_booking_with_passengers(passenger_count: 2)
  FactoryBot.build(:booking) do |booking|
    FactoryBot.build_list(:passenger, passenger_count, booking:)
  end
end
