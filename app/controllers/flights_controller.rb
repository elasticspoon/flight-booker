class FlightsController < ApplicationController
  before_action :set_flight, only: %i[show edit update destroy]
  before_action :set_current_search, only: %i[index]

  # GET /flights or /flights.json
  def index
    @airports = Airport.all
    @flights = execute_search
    @departures = Flight.departure_collection(@flights)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_flight
    @flight = Flight.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def flight_params
    params.permit(:arrival_airport, :departure_airport, :departure).compact_blank
  end

  def set_current_search
    search = flight_params
    departure_time = search[:departure]
    search[:departure] = Flight.departure_range(departure_time) if departure_time
    search[:departure_time] = departure_time
    @current_search = search
  end

  def execute_search
    logger.debug "Searching for flights with params: #{@current_search}"
    search_params = @current_search.except(:departure_time)
    return [] if search_params.empty?

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
