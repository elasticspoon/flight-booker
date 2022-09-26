json.extract! flight, :id, :arrival_airport, :departure_airport, :departure, :duration, :created_at, :updated_at
json.url flight_url(flight, format: :json)
