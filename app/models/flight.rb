class Flight < ApplicationRecord
  has_one :arrival_airport
  has_one :departure_airport
end
