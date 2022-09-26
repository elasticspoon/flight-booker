# rubocop:disable Layout/HashAlignment
class Airport < ApplicationRecord
  has_many :departing_flights,
           class_name: 'Flight',
           foreign_key: 'departure_airport_id',
           inverse_of:  :departure_airport,
           dependent: false
  has_many :arriving_flights,
           class_name: 'Flight',
           foreign_key: 'arrival_airport_id',
           inverse_of:  :arrival_airport,
           dependent: false

  validates :code,
            presence: true,
            uniqueness: true,
            length: { is: 3 },
               format: { with: /\A[A-Z]{3}\z/ }
  validates :location, presence: true
end

# rubocop:enable Layout/HashAlignment
