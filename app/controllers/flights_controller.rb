class FlightsController < ApplicationController
  before_action :set_current_search, only: %i[index]

  # GET /flights or /flights.json
  def index
    @airports = Airport.all
    @flights = execute_search
    @departures = Flight.date_select_helper(@flights)
  end

  private

  # Only allow a list of trusted parameters through.
  def flight_params
    params.permit(:arrival_airport, :departure_airport, :num_passengers, departure: %i[day month year]).compact_blank
  end

  def set_current_search
    search = flight_params
    departure_time = search[:departure]
    search[:departure] = Flight.parse_date_params(departure_time) if departure_time
    search[:departure_time] = departure_time
    @current_search = search
  end

  def execute_search
    search_params = @current_search.except(:departure_time, :num_passengers).compact
    return [] if search_params.empty?

    Flight.where(search_params)
      .order(:departure).includes(:arrival_airport, :departure_airport)
  end
end
