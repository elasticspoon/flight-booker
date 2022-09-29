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

  def self.date_select_helper(flights)
    pretty_flights = departure_collection(flights)
    parse_flights(pretty_flights)
  end

  def self.departure_collection(flights)
    flights.map(&:pretty_departure).uniq
  end

  def self.departure_range(departure_date)
    start_range = Date.strptime(departure_date, '%m/%d/%Y').beginning_of_day
    (start_range..start_range + 1.day)
  end

  def self.parse_date_params(params) # rubocop:disable Metrics/AbcSize
    return nil if params.nil?

    params = params.compact_blank
    case params.keys.sort
    when %w[day month year]
      date = Date.new(params['year'].to_i, params['month'].to_i, params['day'].to_i)
      date..(date + 1.day)
    when %w[month year]
      date = Date.new(params['year'].to_i, params['month'].to_i)
      date..(date + 1.month)
    when ['year']
      date = Date.new(params['year'].to_i)
      date..(date + 1.year)
    end
  end

  def self.parse_flights(flights)
    flights.each_with_object({ month: [], day: [], year: [] }) do |val, sum|
      m, d, y = val.split('/')
      sum[:month] << m
      sum[:day] << d
      sum[:year] << y
    end
    # flights.each do |_k, v|
    #   v&.uniq!
    #   v&.sort!
    # end
  end

  def pretty_arrival
    (departure + duration).strftime('%A %d, %B %Y at %I:%M %p')
  end

  def pretty_departure_full
    departure.strftime('%A %d, %B %Y at %I:%M %p')
  end
end

# rubocop:enable Layout/HashAlignment
