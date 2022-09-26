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
end

# rubocop:enable Layout/HashAlignment
