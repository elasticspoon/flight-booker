FactoryBot.define do
  factory :booking do
    flight
  end
end

def create_booking_with_passengers(passenger_count: 2)
  airports = FactoryBot.create_list(:airport, 2)
  flight = FactoryBot.create(:flight, arrival_airport: airports.first, departure_airport: airports.last)
  booking = FactoryBot.build(:booking, flight:, passengers: FactoryBot.build_list(:passenger, passenger_count))
  booking.save
  booking
end

def build_booking_with_passengers(passenger_count: 2)
  airports = FactoryBot.create_list(:airport, 2)
  flight = FactoryBot.create(:flight, arrival_airport: airports.first, departure_airport: airports.last)
  FactoryBot.build(:booking, flight:, passengers: FactoryBot.build_list(:passenger, passenger_count))
end
