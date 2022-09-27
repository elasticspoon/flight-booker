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

  def pretty_departure
    departure.strftime('%m/%d/%Y')
  end

  def pretty_duration
    hours = duration / 3600
    minutes = (duration % 3600) / 60
    return "#{hours} hour" if minutes.zero?

    "#{hours} hour #{minutes} minutes"
  end

  def self.departure_collection(flights)
    unique_dates = flights.map(&:pretty_departure).uniq
    unique_dates.map { |date| Struct.new(:id, :name).new(date, date) }
  end

  def self.departure_range(departure_date)
    start_range = Date.strptime(departure_date, '%m/%d/%Y').beginning_of_day
    (start_range..start_range + 1.day)
  end
end

# rubocop:enable Layout/HashAlignment
