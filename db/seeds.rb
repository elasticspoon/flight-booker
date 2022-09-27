# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

Airport.delete_all
8.times do
  Airport.create(
    location: "#{Faker::Address.city}, #{Faker::Address.country}",
    code: Faker::Address.unique.country_code_long
  )
end
200.times do
  arrival_airport, departure_airport = Airport.all.sample(2)
  Flight.create(
    arrival_airport:,
    departure_airport:,
    departure: Faker::Time.forward(days: 30, period: :morning),
    duration: Faker::Number.between(from: 3600, to: 86_400)
  )
end
