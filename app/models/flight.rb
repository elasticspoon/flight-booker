# rubocop:disable Layout/HashAlignment
class Flight < ApplicationRecord
  belongs_to :arrival_airport,
             class_name: 'Airport',
             inverse_of:  :arriving_flights,
             primary_key: :code
  belongs_to :departure_airport,
             class_name: 'Airport',
             inverse_of: :departing_flights,
             primary_key: :code
  has_many :bookings, dependent: :destroy, inverse_of: :flight

  validates :departure, :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 3600, less_than: 86_400 }
end

# rubocop:enable Layout/HashAlignment
