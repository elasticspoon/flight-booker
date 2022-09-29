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

    logger.debug "Searching for flights with params: #{@current_search}"
    Flight.where(search_params)
      .order(:departure).includes(:arrival_airport, :departure_airport)
  end

  def search_flights
    @current_search = flight_params
    return [] if @current_search.empty?

    departure_time = @current_search[:departure]
    @current_search[:departure_time] = departure_time
    @current_search[:departure] = Flight.departure_range(departure_time) if departure_time

    Flight.where(@current_search.except(:departure_time))
      .order(:departure).includes(:arrival_airport, :departure_airport)
  end
end
